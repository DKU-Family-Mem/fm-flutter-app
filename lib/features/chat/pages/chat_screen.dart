import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../chat_provider.dart';
import '../widgets/message_bubble.dart';

/// 채팅 화면
/// 가족 구성원과의 실시간 채팅 기능을 제공합니다.
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  String _familyId = 'default_family';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadFamilyId();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // 사용자의 가족 ID 로드
  Future<void> _loadFamilyId() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final chatProvider = Provider.of<ChatProvider>(context, listen: false);
      _familyId = await chatProvider.getUserFamilyId();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('가족 정보 로드 실패: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // 텍스트 메시지 전송
  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    final success = await chatProvider.sendTextMessage(text);

    if (success) {
      _controller.clear();
      // 스크롤을 맨 아래로 이동
      _scrollToBottom();
    } else if (chatProvider.error != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(chatProvider.error!)),
      );
    }
  }

  // 이미지 메시지 전송
  Future<void> _sendImage() async {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    final success = await chatProvider.sendImageMessage();

    if (!success && chatProvider.error != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(chatProvider.error!)),
      );
    } else {
      // 스크롤을 맨 아래로 이동
      _scrollToBottom();
    }
  }

  // 스크롤을 맨 아래로 이동
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('가족 채팅'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // 메시지 목록
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: chatProvider.getMessageStream(_familyId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Text('오류가 발생했습니다: ${snapshot.error}'),
                        );
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text('아직 메시지가 없습니다. 첫 메시지를 보내보세요!'),
                        );
                      }

                      final messages = snapshot.data!.docs;
                      
                      // 새 메시지가 있을 때 스크롤 맨 아래로 이동
                      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

                      return ListView.builder(
                        controller: _scrollController,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index].data() as Map<String, dynamic>;
                          final isMe = message['senderId'] == currentUser?.uid;
                          final isImage = message['type'] == 'image';

                          return MessageBubble(
                            content: message['content'] ?? '',
                            senderName: message['senderName'] ?? '이름없음',
                            senderPhotoUrl: message['senderPhotoUrl'],
                            isMe: isMe,
                            isImage: isImage,
                          );
                        },
                      );
                    },
                  ),
                ),
                
                // 메시지 입력 영역
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      // 이미지 전송 버튼
                      IconButton(
                        icon: const Icon(Icons.image),
                        onPressed: chatProvider.isLoading ? null : _sendImage,
                      ),
                      // 메시지 입력 필드
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: const InputDecoration(
                            hintText: '메시지 입력',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                      // 메시지 전송 버튼
                      IconButton(
                        icon: chatProvider.isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.send),
                        onPressed: chatProvider.isLoading ? null : _sendMessage,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
