import 'package:flutter/material.dart';
import 'app_colors.dart';

// App Typography System
// Based on heoby_web theme.css - elderly-friendly (large fonts)
class AppTypography {
  AppTypography._();

  // Font Family
  static const String fontFamily = 'NanumMyeongjo';
  static const String fontFamilyFallback = 'Noto Sans KR';

  // Font Sizes (mobile - slightly smaller than web)
  static const double fontSizeXs = 12.0; // 14px -> 12px (mobile)
  static const double fontSizeSm = 14.0; // 16px -> 14px
  static const double fontSizeBase = 16.0; // 18px -> 16px (base body)
  static const double fontSizeLg = 18.0; // 20px -> 18px
  static const double fontSizeXl = 20.0; // 24px -> 20px (section titles)
  static const double fontSize2xl = 24.0; // 28px -> 24px (page titles)
  static const double fontSize3xl = 28.0; // extra large
  static const double fontSize4xl = 32.0; // main title

  // Font Weights
  static const FontWeight fontWeightRegular = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w500;
  static const FontWeight fontWeightSemiBold = FontWeight.w600;
  static const FontWeight fontWeightBold = FontWeight.w700;
  static const FontWeight fontWeightExtraBold = FontWeight.w800;

  // Line Heights
  static const double lineHeightTight = 1.35;
  static const double lineHeightNormal = 1.6;
  static const double lineHeightRelaxed = 1.75;

  // Letter Spacing
  static const double letterSpacingTight = -0.5;
  static const double letterSpacingNormal = 0.0;
  static const double letterSpacingWide = 0.5;

  // Text Styles - Display (large headings)
  static TextStyle displayLarge = const TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSize4xl,
    fontWeight: fontWeightBold,
    height: lineHeightTight,
    color: AppColors.textPrimary,
  );

  static TextStyle displayMedium = const TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSize3xl,
    fontWeight: fontWeightBold,
    height: lineHeightTight,
    color: AppColors.textPrimary,
  );

  static TextStyle displaySmall = const TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSize2xl,
    fontWeight: fontWeightBold,
    height: lineHeightNormal,
    color: AppColors.textPrimary,
  );

  // Text Styles - Headline (headings)
  static TextStyle headlineLarge = const TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSize2xl,
    fontWeight: fontWeightBold,
    height: lineHeightNormal,
    color: AppColors.textPrimary,
  );

  static TextStyle headlineMedium = const TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeXl,
    fontWeight: fontWeightSemiBold,
    height: lineHeightNormal,
    color: AppColors.textPrimary,
  );

  static TextStyle headlineSmall = const TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeLg,
    fontWeight: fontWeightSemiBold,
    height: lineHeightNormal,
    color: AppColors.textPrimary,
  );

  // Text Styles - Title
  static TextStyle titleLarge = const TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeXl,
    fontWeight: fontWeightMedium,
    height: lineHeightNormal,
    color: AppColors.textPrimary,
  );

  static TextStyle titleMedium = const TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeLg,
    fontWeight: fontWeightMedium,
    height: lineHeightNormal,
    color: AppColors.textPrimary,
  );

  static TextStyle titleSmall = const TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeBase,
    fontWeight: fontWeightMedium,
    height: lineHeightNormal,
    color: AppColors.textPrimary,
  );

  // Text Styles - Body (content)
  static TextStyle bodyLarge = const TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeBase,
    fontWeight: fontWeightRegular,
    height: lineHeightRelaxed,
    color: AppColors.textPrimary,
  );

  static TextStyle bodyMedium = const TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeSm,
    fontWeight: fontWeightRegular,
    height: lineHeightRelaxed,
    color: AppColors.textPrimary,
  );

  static TextStyle bodySmall = const TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeXs,
    fontWeight: fontWeightRegular,
    height: lineHeightRelaxed,
    color: AppColors.textSecondary,
  );

  // Text Styles - Label
  static TextStyle labelLarge = const TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeBase,
    fontWeight: fontWeightSemiBold,
    height: lineHeightNormal,
    color: AppColors.textPrimary,
  );

  static TextStyle labelMedium = const TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeSm,
    fontWeight: fontWeightSemiBold,
    height: lineHeightNormal,
    color: AppColors.textPrimary,
  );

  static TextStyle labelSmall = const TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeXs,
    fontWeight: fontWeightSemiBold,
    height: lineHeightNormal,
    color: AppColors.textSecondary,
  );

  // Custom Text Styles
  static TextStyle button = const TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeBase,
    fontWeight: fontWeightSemiBold,
    height: 1.2,
    color: AppColors.textOnPrimary,
  );

  static TextStyle caption = const TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeXs,
    fontWeight: fontWeightRegular,
    height: lineHeightNormal,
    color: AppColors.textMuted,
  );

  static TextStyle overline = const TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeXs,
    fontWeight: fontWeightSemiBold,
    height: lineHeightNormal,
    letterSpacing: letterSpacingWide,
    color: AppColors.textMuted,
  );

  static TextStyle data = const TextStyle(
    fontFamily: 'monospace',
    fontSize: fontSizeBase,
    fontWeight: fontWeightMedium,
    height: lineHeightNormal,
    color: AppColors.textPrimary,
  );

  static TextStyle badge = const TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeXs,
    fontWeight: fontWeightBold,
    height: 1.0,
    color: AppColors.textOnPrimary,
  );

  static TextStyle error = const TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeSm,
    fontWeight: fontWeightRegular,
    height: lineHeightNormal,
    color: AppColors.danger,
  );

  static TextStyle success = const TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeSm,
    fontWeight: fontWeightRegular,
    height: lineHeightNormal,
    color: AppColors.success,
  );
}
