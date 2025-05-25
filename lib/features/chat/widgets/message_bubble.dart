import 'package:flutter/material.dart';

/// 채팅 메시지 버블 위젯
/// 
/// [content] 메시지 내용  
/// [senderName] 발신자 이름  
/// [senderPhotoUrl] 발신자 프로필 이미지 URL  
/// [isMe] 현재 사용자가 발신자인지 여부  
/// [isImage] 이미지 메시지인지 여부  
/// [timestamp] 메시지 전송 시각
class MessageBubble extends StatelessWidget {
  final String content;
  final String senderName;
  final String? senderPhotoUrl;
  final bool isMe;
  final bool isImage;
  final DateTime timestamp;

  const MessageBubble({
    super.key,
    required this.content,
    required this.senderName,
    this.senderPhotoUrl,
    required this.isMe,
    this.isImage = false,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    // 시각 포맷팅 (예: 오후 3:21)
    final timeString = _formatTime(timestamp);

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            // 상대방 프로필 이미지
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

          // 메시지 + 시간 + 이름
          Column(
            crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              if (!isMe)
                Text(
                  senderName,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  //  내가 보낸 메시지는 왼쪽에 시간 표시
                  if (isMe)
                    Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: Text(
                        timeString,
                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ),

                  // 메시지 말풍선
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blue[100] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
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

                  //  상대방 메시지는 오른쪽에 시간 표시
                  if (!isMe)
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(
                        timeString,
                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ),
                ],
              ),
            ],
          ),

          if (isMe) const SizedBox(width: 8),
        ],
      ),
    );
  }

  /// 시간을 "오전 3:12" 형식으로 포맷
  String _formatTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final ampm = hour >= 12 ? '오후' : '오전';
    final formattedHour = hour % 12 == 0 ? 12 : hour % 12;
    return '$ampm $formattedHour:$minute';
  }
}
