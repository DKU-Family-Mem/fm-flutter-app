import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _currentUser != null;

  AuthProvider() {
    // 인증 상태 변경 감지
    _authService.authStateChanges.listen((User? user) {
      _currentUser = user;
      notifyListeners();
    });
  }

  // 이메일/비밀번호로 로그인
  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      _setLoading(true);
      _clearError();
      
      final result = await _authService.signInWithEmailAndPassword(email, password);
      
      if (result != null) {
        _currentUser = result.user;
        notifyListeners();
        return true;
      }
      
      // Firebase 오류 메시지 가져오기 (auth_service.dart에서 오류가 발생하면 null이 반환됨)
      // 여기에서는 기본 오류 메시지 설정
      _setError('로그인에 실패했습니다. 이메일과 비밀번호를 확인하세요.');
      return false;
    } on FirebaseAuthException catch (e) {
      // Firebase 인증 예외 처리
      String errorMessage;
      
      switch (e.code) {
        case 'invalid-credential':
          errorMessage = '이메일 또는 비밀번호가 올바르지 않습니다.';
          break;
        case 'user-not-found':
          errorMessage = '해당 이메일로 등록된 계정이 없습니다.';
          break;
        case 'wrong-password':
          errorMessage = '비밀번호가 올바르지 않습니다.';
          break;
        case 'invalid-email':
          errorMessage = '유효하지 않은 이메일 형식입니다.';
          break;
        case 'user-disabled':
          errorMessage = '해당 계정은 비활성화되었습니다. 관리자에게 문의하세요.';
          break;
        case 'too-many-requests':
          errorMessage = '너무 많은 로그인 시도가 있었습니다. 잠시 후 다시 시도하세요.';
          break;
        default:
          errorMessage = '로그인 오류가 발생했습니다: ${e.message}';
      }
      
      _setError(errorMessage);
      print('Firebase 로그인 오류: ${e.code} - $errorMessage');
      return false;
    } catch (e) {
      _setError('로그인 오류: $e');
      print('예상치 못한 로그인 오류: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // 이메일/비밀번호로 회원가입
  Future<bool> createUserWithEmailAndPassword(String email, String password) async {
    try {
      _setLoading(true);
      _clearError();
      
      final result = await _authService.createUserWithEmailAndPassword(email, password);
      
      if (result != null) {
        _currentUser = result.user;
        
        // Firestore에 사용자 정보 저장 - familyId 추가
        await _firestore.collection('users').doc(result.user!.uid).set({
          'email': email,
          'createdAt': Timestamp.now(),
          'nickname': '이름없음',
          'profileUrl': '',
          'familyId': 'default_family', // 기본 가족 ID 설정
        });
        
        notifyListeners();
        return true;
      }
      
      _setError('회원가입에 실패했습니다.');
      return false;
    } on FirebaseAuthException catch (e) {
      // Firebase 인증 예외 처리
      String errorMessage;
      
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = '이미 사용 중인 이메일입니다. 다른 이메일을 사용하세요.';
          break;
        case 'weak-password':
          errorMessage = '비밀번호가 너무 약합니다. 6자 이상의 강력한 비밀번호를 사용하세요.';
          break;
        case 'invalid-email':
          errorMessage = '유효하지 않은 이메일 형식입니다.';
          break;
        case 'operation-not-allowed':
          errorMessage = '이메일/비밀번호 로그인이 비활성화되어 있습니다. 관리자에게 문의하세요.';
          break;
        default:
          errorMessage = '회원가입 오류가 발생했습니다: ${e.message}';
      }
      
      _setError(errorMessage);
      print('Firebase 회원가입 오류: ${e.code} - $errorMessage');
      return false;
    } catch (e) {
      _setError('회원가입 오류: $e');
      print('예상치 못한 회원가입 오류: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Google 계정으로 로그인
  Future<bool> signInWithGoogle() async {
    try {
      _setLoading(true);
      _clearError();
      
      final result = await _authService.signInWithGoogle();
      
      if (result != null) {
        _currentUser = result.user;
        
        // Firestore에 사용자 정보 저장 또는 업데이트 - Google 로그인 사용자도 familyId 필드 추가
        final userDoc = await _firestore.collection('users').doc(result.user!.uid).get();
        
        if (!userDoc.exists) {
          // 신규 사용자인 경우
          await _firestore.collection('users').doc(result.user!.uid).set({
            'email': result.user!.email,
            'nickname': result.user!.displayName ?? '이름없음',
            'profileUrl': result.user!.photoURL ?? '',
            'createdAt': Timestamp.now(),
            'familyId': 'default_family', // 기본 가족 ID 설정
          });
        }
        
        notifyListeners();
        return true;
      }
      
      _setError('Google 로그인에 실패했습니다.');
      return false;
    } catch (e) {
      _setError('Google 로그인 오류: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // 로그아웃
  Future<void> signOut() async {
    try {
      _setLoading(true);
      await _authService.signOut();
      _currentUser = null;
      notifyListeners();
    } catch (e) {
      _setError('로그아웃 오류: $e');
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