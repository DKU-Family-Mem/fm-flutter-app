class ChatMessage {
  final String id;
  final String uid; // 발신자 ID
  final String text;
  final DateTime timestamp;
  final bool isMe;
  final bool isRead;

  ChatMessage({
    required this.id,
    required this.uid,
    required this.text,
    required this.timestamp,
    required this.isMe,
    this.isRead = false,
  });

  factory ChatMessage.fromMap(Map<String, dynamic> map, String currentUserId) {
    return ChatMessage(
      id: map['id'],
      uid: map['uid'],
      text: map['text'],
      timestamp: DateTime.parse(map['timestamp'].toString()),
      isMe: map['uid'] == currentUserId,
      isRead: map['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
    };
  }
} 