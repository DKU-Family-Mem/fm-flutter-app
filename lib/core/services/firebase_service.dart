import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // 사용자 컬렉션 참조
  CollectionReference get usersCollection => _firestore.collection('users');
  
  // 채팅 메시지 컬렉션 참조 
  CollectionReference get messagesCollection => _firestore.collection('messages');
  
  // 다이어리 컬렉션 참조
  CollectionReference get diariesCollection => _firestore.collection('diaries');

  // 특정 사용자의 다이어리 가져오기
  Stream<QuerySnapshot> getUserDiaries(String userId) {
    return diariesCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // 특정 다이어리 조회
  Future<DocumentSnapshot> getDiaryById(String diaryId) {
    return diariesCollection.doc(diaryId).get();
  }

  // 다이어리 추가
  Future<DocumentReference> addDiary(Map<String, dynamic> diaryData) {
    return diariesCollection.add(diaryData);
  }

  // 다이어리 업데이트
  Future<void> updateDiary(String diaryId, Map<String, dynamic> diaryData) {
    return diariesCollection.doc(diaryId).update(diaryData);
  }

  // 다이어리 삭제
  Future<void> deleteDiary(String diaryId) {
    return diariesCollection.doc(diaryId).delete();
  }

  // 채팅 메시지 저장
  Future<DocumentReference> addMessage(Map<String, dynamic> messageData) {
    return messagesCollection.add(messageData);
  }

  // 채팅 메시지 스트림 가져오기
  Stream<QuerySnapshot> getChatMessages(String userId) {
    return messagesCollection
        .where('uid', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // 이미지 스토리지에 업로드
  Future<String> uploadImage(String userId, String filePath, String fileName) async {
    Reference storageRef = _storage.ref().child('users/$userId/images/$fileName');
    UploadTask uploadTask = storageRef.putFile(File(filePath));
    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }
} 