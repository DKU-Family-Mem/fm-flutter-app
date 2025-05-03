import 'package:flutter/material.dart';
import '../../core/models/diary_entry.dart';

class DiaryProvider with ChangeNotifier {
  final List<DiaryEntry> _diaries = [];
  bool _isLoading = false;

  List<DiaryEntry> get diaries => _diaries;
  bool get isLoading => _isLoading;

  // TODO: Firebase 서비스 연결
  // final FirebaseService _firebaseService = FirebaseService();

  // 다이어리 목록 로드
  Future<void> loadDiaries(String userId) async {
    try {
      _setLoading(true);
      
      // TODO: Firebase 연동 후 주석 해제
      // Firebase로부터 다이어리 스트림 수신
      /*
      _firebaseService.getUserDiaries(userId).listen((snapshot) {
        _diaries.clear();
        
        for (var doc in snapshot.docs) {
          var data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          _diaries.add(DiaryEntry.fromMap(data));
        }
        
        notifyListeners();
      });
      */
      
      // 임시 데이터
      _diaries.clear();
      _diaries.add(
        DiaryEntry(
          id: '1',
          userId: userId,
          title: '샘플 다이어리',
          content: '이것은 샘플 다이어리 내용입니다. Firebase가 연결되면 실제 데이터로 대체됩니다.',
          createdAt: DateTime.now(),
          isAIGenerated: false,
        ),
      );
      _diaries.add(
        DiaryEntry(
          id: '2',
          userId: userId,
          title: 'AI 생성 샘플',
          content: '이것은 AI가 생성한 샘플 다이어리 내용입니다. 실제로는 OpenAI API 등을 통해 생성됩니다.',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          isAIGenerated: true,
        ),
      );
      
      notifyListeners();
    } catch (e) {
      print('다이어리 로드 오류: $e');
    } finally {
      _setLoading(false);
    }
  }

  // 개별 다이어리 조회
  Future<DiaryEntry?> getDiaryById(String diaryId) async {
    try {
      // TODO: Firebase 연동 후 주석 해제
      /*
      final doc = await _firebaseService.getDiaryById(diaryId);
      if (!doc.exists) return null;
      
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return DiaryEntry.fromMap(data);
      */
      
      // 임시 구현
      return _diaries.firstWhere((diary) => diary.id == diaryId);
    } catch (e) {
      print('다이어리 조회 오류: $e');
      return null;
    }
  }

  // 다이어리 추가
  Future<void> addDiary({
    required String userId,
    required String title,
    required String content,
    List<String>? imageUrls,
    List<String>? tags,
    bool isAIGenerated = false,
  }) async {
    try {
      // TODO: UUID 패키지 추가 필요
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      final now = DateTime.now();
      
      final diary = DiaryEntry(
        id: id,
        userId: userId,
        title: title,
        content: content,
        createdAt: now,
        imageUrls: imageUrls,
        tags: tags,
        isAIGenerated: isAIGenerated,
      );
      
      // TODO: Firebase 연동 후 주석 해제
      // await _firebaseService.addDiary(diary.toMap());
      
      // 임시 구현
      _diaries.add(diary);
      notifyListeners();
    } catch (e) {
      print('다이어리 추가 오류: $e');
    }
  }

  // 다이어리 업데이트
  Future<void> updateDiary({
    required String id,
    String? title,
    String? content,
    List<String>? imageUrls,
    List<String>? tags,
  }) async {
    try {
      // 기존 다이어리 찾기
      final index = _diaries.indexWhere((d) => d.id == id);
      if (index == -1) return;
      
      final existingDiary = _diaries[index];
      final updatedDiary = existingDiary.copyWith(
        title: title,
        content: content,
        updatedAt: DateTime.now(),
        imageUrls: imageUrls,
        tags: tags,
      );
      
      // TODO: Firebase 연동 후 주석 해제
      // await _firebaseService.updateDiary(id, updatedDiary.toMap());
      
      // 임시 구현
      _diaries[index] = updatedDiary;
      notifyListeners();
    } catch (e) {
      print('다이어리 업데이트 오류: $e');
    }
  }

  // 다이어리 삭제
  Future<void> deleteDiary(String id) async {
    try {
      // TODO: Firebase 연동 후 주석 해제
      // await _firebaseService.deleteDiary(id);
      
      // 임시 구현
      _diaries.removeWhere((diary) => diary.id == id);
      notifyListeners();
    } catch (e) {
      print('다이어리 삭제 오류: $e');
    }
  }
  
  // 로딩 상태 설정
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
} 