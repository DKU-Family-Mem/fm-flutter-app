import 'dart:io'; // Platform 체크를 위해 추가
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// 임포트 경로 수정
import 'core/constants/app_colors.dart';
import 'features/auth/auth_provider.dart' as app_auth;
import 'features/auth/pages/login_screen.dart';
import 'features/diary/diary_provider.dart';
import 'features/chat/chat_provider.dart';
import 'features/chat/pages/chat_screen.dart';
import 'firebase_options.dart';
import 'router/app_router.dart';
import 'services/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // .env 파일 로드
  await dotenv.load(fileName: '.env');
  
  // Android 또는 iOS 플랫폼에서만 실행되도록 체크
  if (!Platform.isAndroid && !Platform.isIOS) {
    print('이 앱은 Android 및 iOS 플랫폼에서만 지원됩니다.');
    return; // 지원되지 않는 플랫폼에서는 앱 초기화 중단
  }
  
  // TODO: Firebase 초기화 - firebase_options.dart 파일 생성 필요
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Firebase 초기화 오류: $e');
    // Firebase 없이도 앱이 실행되도록 임시 코드
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // 서비스
        Provider<AuthService>(create: (_) => AuthService()),
        
        // 프로바이더들
        ChangeNotifierProvider(create: (_) => app_auth.AuthProvider()),
        ChangeNotifierProvider(create: (context) {
          // TODO: DiaryProvider 초기화를 위한 Firebase 서비스 연결 필요
          // 임시로 빈 객체 생성
          return DiaryProvider();
        }),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        
        // Firebase Auth 상태
        StreamProvider<User?>.value(
          value: FirebaseAuth.instance.authStateChanges(),
          initialData: null,
        ),
      ],
      child: MaterialApp(
        title: 'DKU Family Memory',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
          useMaterial3: true,
          // TODO: 전체 앱에 적용할 기본 테마 설정
        ),
        navigatorKey: AppRouter.navigatorKey,
        // onGenerateRoute: AppRouter.generateRoute, // 라우터 설정 - 나중에 구현
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Firebase 인증 상태 변화 감지
    final firebaseUser = context.watch<User?>();
    
    // 로그인 상태에 따라 화면 전환
    if (firebaseUser != null) {
      // TODO: 홈 화면 구현 필요
      return Scaffold(
        appBar: AppBar(
          title: const Text('홈 화면'),
          backgroundColor: AppColors.primaryColor,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                final authProvider = Provider.of<app_auth.AuthProvider>(context, listen: false);
                await authProvider.signOut();
              },
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('로그인되었습니다!'),
              SizedBox(height: 16),
              Text('사용자 이메일: ${firebaseUser.email ?? '정보 없음'}'),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // TODO: 다이어리 목록 화면으로 이동
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => DiaryListScreen()));
                },
                child: Text('다이어리 화면으로 이동'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => const ChatScreen())
                  );
                },
                child: Text('가족 채팅 시작하기'),
              ),
            ],
          ),
        ),
      );
    }
    
    // 로그인되지 않은 경우 로그인 화면으로 이동
    return const LoginScreen();
  }
}
