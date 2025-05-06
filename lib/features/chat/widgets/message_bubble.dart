import 'package:flutter/material.dart';

/// 채팅 메시지 버블 위젯
/// 
/// [content] 메시지 내용
/// [senderName] 발신자 이름
/// [senderPhotoUrl] 발신자 프로필 이미지 URL
/// [isMe] 현재 사용자가 발신자인지 여부
/// [isImage] 이미지 메시지인지 여부
class MessageBubble extends StatelessWidget {
  final String content;
  final String senderName;
  final String? senderPhotoUrl;
  final bool isMe;
  final bool isImage;

  const MessageBubble({
    super.key,
    required this.content,
    required this.senderName,
    this.senderPhotoUrl,
    required this.isMe,
    this.isImage = false,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상대방 메시지일 경우 프로필 이미지 표시
          if (!isMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundImage: senderPhotoUrl != null && senderPhotoUrl!.isNotEmpty
                  ? NetworkImage(senderPhotoUrl!)
                  : null,
              child: senderPhotoUrl == null || senderPhotoUrl!.isEmpty
                  ? const Icon(Icons.person, size: 16)
                  : null,
            ),
            const SizedBox(width: 8),
          ],
          // 메시지 내용
          Column(
            crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              // 상대방 메시지일 경우 이름 표시
              if (!isMe)
                Text(
                  senderName,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              // 메시지 버블
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: isMe ? Colors.blue[100] : Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                // 이미지 메시지 또는 텍스트 메시지 표시
                child: isImage
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          content,
                          width: 150,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return SizedBox(
                              width: 150,
                              height: 150,
                              child: Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const SizedBox(
                              width: 150,
                              height: 100,
                              child: Center(
                                child: Text('이미지를 불러올 수 없습니다.'),
                              ),
                            );
                          },
                        ),
                      )
                    : Text(content),
              ),
            ],
          ),
          // 오른쪽 여백 (나의 메시지)
          if (isMe) const SizedBox(width: 40),
        ],
      ),
    );
  }
} 