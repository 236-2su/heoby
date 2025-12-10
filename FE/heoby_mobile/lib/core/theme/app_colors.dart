import 'package:flutter/material.dart';

/// 앱 색상 팔레트
/// heoby_web의 theme.css를 기반으로 한 색상 시스템
/// OKLCH 색상을 Flutter Color로 변환
class AppColors {
  AppColors._();

  // Primary Colors (따뜻한 갈색/오렌지 톤 - 노인 친화적)
  static const Color primary600 = Color(0xFFB8875C); // oklch(50% 0.13 40)
  static const Color primary700 = Color(0xFF8F6540); // oklch(43% 0.13 40)
  static const Color primary = primary600;
  static const Color primaryDark = primary700;

  // Accent Colors (BottomNavBar 등에 사용)
  static const Color accent = Color(0xFFFFD54F); // 따뜻한 금색/노란색
  static const Color accentLight = Color(0xFFFFE082);
  static const Color accentDark = Color(0xFFFFC107);

  // Background Colors (따뜻한 흰색)
  static const Color background = Color(0xFFFDFCFB); // oklch(99% 0.005 80)
  static const Color backgroundAlt = Color(0xFFF5F3EF); // oklch(96% 0.01 85) - 연한 베이지
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceAlt = Color(0xFFF9F8F6);

  // Text Colors (갈색 계열)
  static const Color textPrimary = Color(0xFF2B2622); // oklch(15% 0.01 70) - 어두운 갈색
  static const Color textSecondary = Color(0xFF5C5349); // oklch(30% 0.01 70) - 중간 갈색
  static const Color textMuted = Color(0xFF8A8179); // 연한 갈색
  static const Color textDisabled = Color(0xFFBDB9B3);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Semantic Colors
  static const Color success = Color(0xFF7CB342); // oklch(55% 0.1 140) - 따뜻한 톤의 녹색
  static const Color successLight = Color(0xFF9CCC65);
  static const Color successDark = Color(0xFF558B2F);

  static const Color warning = Color(0xFFFFA726); // oklch(60% 0.12 75) - 노란색/오렌지 경고
  static const Color warningLight = Color(0xFFFFB74D);
  static const Color warningDark = Color(0xFFF57C00);

  static const Color danger = Color(0xFFE53935); // oklch(50% 0.12 25) - 빨간색 경고
  static const Color dangerLight = Color(0xFFEF5350);
  static const Color dangerDark = Color(0xFFC62828);

  static const Color info = Color(0xFF42A5F5);
  static const Color infoLight = Color(0xFF64B5F6);
  static const Color infoDark = Color(0xFF1976D2);

  // Border Colors
  static const Color border = Color(0xFFE5E3DF);
  static const Color borderLight = Color.fromRGBO(15, 23, 42, 0.3);
  static const Color borderDark = Color(0xFFD0CCC5);
  static const Color borderFocus = Color(0xFF403D38); // oklch(25% 0 0)

  // Status Colors (허수아비 상태)
  static const Color statusNormal = success; // 정상
  static const Color statusWarning = warning; // 주의
  static const Color statusDanger = danger; // 위험
  static const Color statusOffline = Color(0xFF9E9E9E); // 오프라인

  // Shadow Colors
  static const Color shadow = Color(0x1A000000);
  static const Color shadowMedium = Color(0x33000000);
  static const Color shadowStrong = Color(0x4D000000);

  // Focus Ring Color (접근성)
  static Color focusRing = primary600.withValues(alpha: 0.85);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFEEEDEC), // 연한 베이지
      Color(0xFFF0E6C6), // 연한 크림색
    ],
  );

  static const LinearGradient profileGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF667EEA), // 보라-파랑
      Color(0xFF764BA2), // 보라
    ],
  );

  // Chart/Graph Colors (데이터 시각화)
  static const List<Color> chartColors = [
    Color(0xFFB8875C), // primary
    Color(0xFF7CB342), // success
    Color(0xFF42A5F5), // info
    Color(0xFFFFA726), // warning
    Color(0xFFE53935), // danger
  ];
}
