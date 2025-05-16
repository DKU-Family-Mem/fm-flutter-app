class UserModel {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoURL;
  final DateTime createdAt;
  final DateTime lastLogin;
  final String? familyId;
  final String? nickname;
  final String? profileUrl;

  UserModel({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoURL,
    required this.createdAt,
    required this.lastLogin,
    this.familyId = 'default_family',
    this.nickname,
    this.profileUrl,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      displayName: map['displayName'],
      photoURL: map['photoURL'],
      createdAt: DateTime.parse(map['createdAt'].toString()),
      lastLogin: DateTime.parse(map['lastLogin'].toString()),
      familyId: map['familyId'] ?? 'default_family',
      nickname: map['nickname'],
      profileUrl: map['profileUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'createdAt': createdAt.toIso8601String(),
      'lastLogin': lastLogin.toIso8601String(),
      'familyId': familyId,
      'nickname': nickname,
      'profileUrl': profileUrl,
    };
  }
} 
