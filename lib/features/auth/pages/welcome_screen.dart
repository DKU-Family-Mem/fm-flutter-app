import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

/// 앱 초기 접속 시 표시되는 환영 화면
/// 로그인, 회원가입으로 이동할 수 있는 버튼을 제공합니다.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 상태바 스타일 설정
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).colorScheme.primary.withOpacity(0.8),
                Theme.of(context).colorScheme.primary,
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  // 앱 로고 또는 환영 이미지
                  _buildWelcomeImage(),
                  const SizedBox(height: 30),
                  // 환영 텍스트
                  _buildWelcomeText(),
                  const SizedBox(height: 80),
                  // 로그인 및 회원가입 버튼
                  _buildActionButtons(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 환영 이미지 위젯
  Widget _buildWelcomeImage() {
    return Container(
      height: 200,
      width: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: const Center(
        // TODO: 앱 로고 이미지로 교체
        child: Icon(
          Icons.family_restroom,
          size: 100,
          color: Colors.blue,
        ),
      ),
    );
  }

  /// 환영 텍스트 위젯
  Widget _buildWelcomeText() {
    return const Column(
      children: [
        Text(
          '우리 가족 소통 앱',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20),
        Text(
          '가족과의 소중한 추억과 일상을 함께 나눠보세요.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  /// 로그인 및 회원가입 버튼 위젯
  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // 로그인 버튼
        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.blue,
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              '로그인',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        // 회원가입 버튼
        SizedBox(
          width: double.infinity,
          height: 55,
          child: OutlinedButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const SignupScreen()),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              '회원가입',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
} 