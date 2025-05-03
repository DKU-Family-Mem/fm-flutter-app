import 'package:flutter/material.dart';
import '../../core/services/ai_service.dart';
import '../../core/services/firebase_service.dart';
import '../../core/models/diary_entry.dart';
import '../diary/diary_provider.dart';

class AIDiaryProvider with ChangeNotifier {
  final AIService _aiService = AIService();
  final FirebaseService _firebaseService = FirebaseService();
  final DiaryProvider _diaryProvider;

  String _generatedContent = '';
  bool _isLoading = false;
  bool _isSuccess = false;
  String _errorMessage = '';

  AIDiaryProvider(this._diaryProvider);

  String get generatedContent => _generatedContent;
  bool get isLoading => _isLoading;
  bool get isSuccess => _isSuccess;
  String get errorMessage => _errorMessage;

  // 채팅 기록에서 다이어리 생성 요청
  Future<void> generateDiaryFromChat(List<String> chatMessages, String userId) async {
    try {
      _setLoading(true);
      _resetState();

      // AI 서비스를 통해 다이어리 컨텐츠 생성
      final content = await _aiService.generateDiaryFromChat(chatMessages);
      
      // 생성된 내용 저장
      _generatedContent = content;
      _isSuccess = true;
      notifyListeners();
    } catch (e) {
      _setError('다이어리 생성 중 오류가 발생했습니다: $e');
    } finally {
      _setLoading(false);
    }
  }

  // 생성된 AI 다이어리를 저장
  Future<void> saveAIDiary({
    required String userId,
    required String title,
    required String content,
    List<String>? tags,
  }) async {
    try {
      _setLoading(true);
      
      await _diaryProvider.addDiary(
        userId: userId,
        title: title,
        content: content,
        tags: tags,
        isAIGenerated: true,
      );
      
      _isSuccess = true;
      notifyListeners();
    } catch (e) {
      _setError('다이어리 저장 중 오류가 발생했습니다: $e');
    } finally {
      _setLoading(false);
    }
  }

  // 다이어리 내용 분석 (감정/키워드 등)
  Future<Map<String, dynamic>> analyzeDiaryContent(String content) async {
    try {
      _setLoading(true);
      
      // AI 서비스를 통해 감정 분석
      final sentiment = await _aiService.analyzeSentiment(content);
      
      return sentiment;
    } catch (e) {
      _setError('다이어리 분석 중 오류가 발생했습니다: $e');
      return {};
    } finally {
      _setLoading(false);
    }
  }

  // 다이어리 내용 요약
  Future<String> summarizeDiaryContent(String content) async {
    try {
      _setLoading(true);
      
      // AI 서비스를 통해 내용 요약
      final summary = await _aiService.summarizeDiary(content);
      
      return summary;
    } catch (e) {
      _setError('다이어리 요약 중 오류가 발생했습니다: $e');
      return '';
    } finally {
      _setLoading(false);
    }
  }

  // 로딩 상태 설정
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // 에러 상태 설정
  void _setError(String message) {
    _errorMessage = message;
    _isSuccess = false;
    notifyListeners();
  }

  // 상태 초기화
  void _resetState() {
    _generatedContent = '';
    _isSuccess = false;
    _errorMessage = '';
    notifyListeners();
  }
} 