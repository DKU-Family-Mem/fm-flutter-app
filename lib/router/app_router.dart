import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../features/auth/pages/login_screen.dart';
import '../features/auth/pages/signup_screen.dart';
import '../features/diary/pages/diary_list_screen.dart';
import '../features/chat/pages/chat_screen.dart';
import '../features/ai_diary/ai_diary_screen.dart';
import '../ui/home_screen.dart';

class AppRouter {
  // 앱 라우트 정의
  static const String home = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String diary = '/diary';
  static const String chat = '/chat';
  static const String aiDiary = '/ai_diary';

  // 네비게이터 키 (전역 접근용)
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // 라우트 생성 함수
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      
      case signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      
      case diary:
        return MaterialPageRoute(builder: (_) => const DiaryListScreen());
      
      case chat:
        return MaterialPageRoute(builder: (_) => const ChatScreen());
      
      case aiDiary:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => AIDiaryScreen(
            chatMessages: args['chatMessages'] as List<String>,
            userId: args['userId'] as String,
          ),
        );
      
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }

  // 라우트로 이동 (현재 컨텍스트 없이 사용 가능)
  static Future<dynamic> navigateTo(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushNamed(routeName, arguments: arguments);
  }

  // 이전 화면으로 돌아가기
  static void goBack() {
    navigatorKey.currentState!.pop();
  }

  // 홈 화면으로 이동하고 스택 초기화
  static void navigateToHomeAndClear() {
    navigatorKey.currentState!.pushNamedAndRemoveUntil(
      home,
      (Route<dynamic> route) => false,
    );
  }

  // 로그인 화면으로 이동하고 스택 초기화 (로그아웃 시)
  static void navigateToLoginAndClear() {
    navigatorKey.currentState!.pushNamedAndRemoveUntil(
      login,
      (Route<dynamic> route) => false,
    );
  }
} 