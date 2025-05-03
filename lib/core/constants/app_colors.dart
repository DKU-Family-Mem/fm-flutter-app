import 'package:flutter/material.dart';

class AppColors {
  // 앱 테마 색상
  static const Color primaryColor = Color(0xFF673AB7);         // 보라색
  static const Color primaryLightColor = Color(0xFFD1C4E9);    // 연한 보라색
  static const Color primaryDarkColor = Color(0xFF512DA8);     // 어두운 보라색
  static const Color accentColor = Color(0xFFFF9800);          // 오렌지색

  // 기능별 색상
  static const Color chatBubbleMe = Color(0xFFE3F2FD);         // 내 채팅 버블
  static const Color chatBubbleOther = Color(0xFFF5F5F5);      // 다른 사람 채팅 버블
  static const Color diaryCardBackground = Color(0xFFEDE7F6);  // 다이어리 카드 배경
  static const Color aiGeneratedBg = Color(0xFFFFF3E0);        // AI 생성 콘텐츠 배경
  
  // 상태 색상
  static const Color success = Color(0xFF4CAF50);              // 성공 상태
  static const Color error = Color(0xFFF44336);                // 에러 상태
  static const Color warning = Color(0xFFFF9800);              // 경고 상태
  static const Color info = Color(0xFF2196F3);                 // 정보 상태

  // 텍스트 색상
  static const Color textPrimary = Color(0xFF212121);          // 기본 텍스트
  static const Color textSecondary = Color(0xFF757575);        // 부제목 텍스트
  static const Color textHint = Color(0xFF9E9E9E);             // 힌트 텍스트

  // 배경 색상
  static const Color background = Color(0xFFFAFAFA);           // 앱 배경
  static const Color cardBackground = Colors.white;            // 카드 배경
  static const Color divider = Color(0xFFBDBDBD);              // 구분선
} 