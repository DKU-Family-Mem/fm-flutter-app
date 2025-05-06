import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

/// 채팅 기능의 상태 관리를 담당하는 프로바이더 클래스
class ChatProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  bool _isLoading = false;
  String? _error;
  
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  /// 가족 ID에 해당하는 메시지 스트림을 반환합니다.
  Stream<QuerySnapshot> getMessageStream(String familyId) {
    return _firestore
        .collection('families')
        .doc(familyId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
  
  /// 현재 사용자가 속한 가족 ID를 조회합니다.
  Future<String> getUserFamilyId() async {
    final user = _auth.currentUser;
    if (user == null) {
      _setError('로그인 상태가 아닙니다.');
      return 'default_family';
    }
    
    try {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      final data = userDoc.data();
      return data?['familyId'] ?? 'default_family';
    } catch (e) {
      _setError('가족 정보 조회 실패: $e');
      return 'default_family';
    }
  }
  
  /// 텍스트 메시지를 전송합니다.
  Future<bool> sendTextMessage(String text) async {
    if (text.trim().isEmpty) return false;
    
    final user = _auth.currentUser;
    if (user == null) {
      _setError('로그인 상태가 아닙니다.');
      return false;
    }
    
    _setLoading(true);
    
    try {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      final data = userDoc.data();
      final familyId = data?['familyId'] ?? 'default_family';
      final nickname = data?['nickname'] ?? '이름없음';
      final profileUrl = data?['profileUrl'] ?? '';
      
      await _firestore
          .collection('families')
          .doc(familyId)
          .collection('messages')
          .add({
        'senderId': user.uid,
        'senderName': nickname,
        'senderPhotoUrl': profileUrl,
        'content': text,
        'type': 'text',
        'timestamp': Timestamp.now(),
      });
      
      return true;
    } catch (e) {
      _setError('메시지 전송 실패: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  /// 이미지 메시지를 전송합니다.
  Future<bool> sendImageMessage() async {
    final user = _auth.currentUser;
    if (user == null) {
      _setError('로그인 상태가 아닙니다.');
      return false;
    }
    
    _setLoading(true);
    
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      
      if (pickedFile == null) {
        _setLoading(false);
        return false;
      }
      
      final file = File(pickedFile.path);
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final storageRef = _storage.ref().child('chat_images/$fileName');
      
      await storageRef.putFile(file);
      final imageUrl = await storageRef.getDownloadURL();
      
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      final data = userDoc.data();
      final familyId = data?['familyId'] ?? 'default_family';
      final nickname = data?['nickname'] ?? '이름없음';
      final profileUrl = data?['profileUrl'] ?? '';
      
      await _firestore
          .collection('families')
          .doc(familyId)
          .collection('messages')
          .add({
        'senderId': user.uid,
        'senderName': nickname,
        'senderPhotoUrl': profileUrl,
        'content': imageUrl,
        'type': 'image',
        'timestamp': Timestamp.now(),
      });
      
      return true;
    } catch (e) {
      _setError('이미지 전송 실패: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  // 로딩 상태 설정
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  // 에러 설정
  void _setError(String? message) {
    _error = message;
    notifyListeners();
  }
  
  // 에러 초기화
  void _clearError() {
    _error = null;
    notifyListeners();
  }
}
