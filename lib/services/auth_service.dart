import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // 인증 상태 변경 감지 스트림
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // 현재 사용자 가져오기
  User? get currentUser => _firebaseAuth.currentUser;

  // 이메일/비밀번호로 로그인
  Future<UserCredential?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      print('로그인 시도: $email, 비밀번호 길이: ${password.length}');

      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      // 오류 코드와 메시지를 상세히 출력
      print('로그인 오류: ${e.code}');
      print('오류 메시지: ${e.message}');
      
      if (e.code == 'invalid-credential') {
        print('인증 정보가 올바르지 않습니다. 이메일과 비밀번호를 확인하세요.');
      } else if (e.code == 'user-not-found') {
        print('해당 이메일의 사용자가 존재하지 않습니다.');
      } else if (e.code == 'wrong-password') {
        print('비밀번호가 틀렸습니다.');
      }
      
      return null;
    } catch (e) {
      print('로그인 중 예상치 못한 오류: $e');
      return null;
    }
  }

  // 이메일/비밀번호로 회원가입
  Future<UserCredential?> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      print('회원가입 시도: $email, 비밀번호 길이: ${password.length}');

      return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      print('회원가입 오류: ${e.code}');
      print('오류 메시지: ${e.message}');
      
      if (e.code == 'email-already-in-use') {
        print('이미 사용 중인 이메일입니다.');
      } else if (e.code == 'weak-password') {
        print('비밀번호가 너무 약합니다.');
      } else if (e.code == 'invalid-email') {
        print('유효하지 않은 이메일 형식입니다.');
      }
      
      return null;
    } catch (e) {
      print('회원가입 중 예상치 못한 오류: $e');
      return null;
    }
  }

  // Google 계정으로 로그인
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // TODO: Firebase 연결 후에 실제 인증 로직 구현
      // 임시 구현: Firebase가 없을 때도 앱을 테스트할 수 있도록 더미 응답 제공
      print('Google 로그인 시도');
      
      // Google 로그인 흐름 시작
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // 사용자가 로그인을 취소함
        return null;
      }

      // Google 로그인 정보에서 인증 토큰 가져오기
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Firebase에 Google 계정으로 로그인
      return await _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      // 오류 처리
      print('Google 로그인 오류: ${e.code}');
      return null;
    } catch (e) {
      print('Google 로그인 중 예상치 못한 오류: $e');
      return null;
    }
  }

  // 로그아웃
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut(); // Google 로그아웃
      await _firebaseAuth.signOut(); // Firebase 로그아웃
    } catch (e) {
      print('로그아웃 오류: $e');
    }
  }
}
