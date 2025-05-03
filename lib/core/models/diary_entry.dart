class DiaryEntry {
  final String id;
  final String userId;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<String>? imageUrls;
  final List<String>? tags;
  final bool isAIGenerated;

  DiaryEntry({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.createdAt,
    this.updatedAt,
    this.imageUrls,
    this.tags,
    this.isAIGenerated = false,
  });

  factory DiaryEntry.fromMap(Map<String, dynamic> map) {
    return DiaryEntry(
      id: map['id'],
      userId: map['userId'],
      title: map['title'],
      content: map['content'],
      createdAt: DateTime.parse(map['createdAt'].toString()),
      updatedAt: map['updatedAt'] != null 
          ? DateTime.parse(map['updatedAt'].toString()) 
          : null,
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      tags: List<String>.from(map['tags'] ?? []),
      isAIGenerated: map['isAIGenerated'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'imageUrls': imageUrls,
      'tags': tags,
      'isAIGenerated': isAIGenerated,
    };
  }

  DiaryEntry copyWith({
    String? id,
    String? userId,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? imageUrls,
    List<String>? tags,
    bool? isAIGenerated,
  }) {
    return DiaryEntry(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      imageUrls: imageUrls ?? this.imageUrls,
      tags: tags ?? this.tags,
      isAIGenerated: isAIGenerated ?? this.isAIGenerated,
    );
  }
} 