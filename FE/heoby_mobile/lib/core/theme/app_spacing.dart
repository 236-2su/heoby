import 'package:flutter/material.dart';

// App Spacing and Sizing System
// Based on heoby_web theme.css spacing/sizing system
class AppSpacing {
  AppSpacing._();

  // Base Spacing Units (4px base)
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xl2 = 24.0;
  static const double xl3 = 32.0;
  static const double xl4 = 40.0;
  static const double xl5 = 48.0;
  static const double xl6 = 64.0;

  // Special Spacing (from web theme.css)
  static const double tap = 44.0; // Minimum touch target size (accessibility)
  static const double gap = 12.0; // Default control gap

  // Padding Presets
  static const EdgeInsets paddingXs = EdgeInsets.all(xs);
  static const EdgeInsets paddingSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingMd = EdgeInsets.all(md);
  static const EdgeInsets paddingLg = EdgeInsets.all(lg);
  static const EdgeInsets paddingXl = EdgeInsets.all(xl);
  static const EdgeInsets paddingXl2 = EdgeInsets.all(xl2);
  static const EdgeInsets paddingXl3 = EdgeInsets.all(xl3);

  // Horizontal Padding
  static const EdgeInsets paddingHorizontalXs = EdgeInsets.symmetric(horizontal: xs);
  static const EdgeInsets paddingHorizontalSm = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets paddingHorizontalMd = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets paddingHorizontalLg = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets paddingHorizontalXl = EdgeInsets.symmetric(horizontal: xl);

  // Vertical Padding
  static const EdgeInsets paddingVerticalXs = EdgeInsets.symmetric(vertical: xs);
  static const EdgeInsets paddingVerticalSm = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets paddingVerticalMd = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets paddingVerticalLg = EdgeInsets.symmetric(vertical: lg);
  static const EdgeInsets paddingVerticalXl = EdgeInsets.symmetric(vertical: xl);

  // Page/Section Padding
  static const EdgeInsets pagePadding = EdgeInsets.all(lg);
  static const EdgeInsets sectionPadding = EdgeInsets.symmetric(horizontal: lg, vertical: xl);
  static const EdgeInsets cardPadding = EdgeInsets.all(lg);
  static const EdgeInsets listItemPadding = EdgeInsets.symmetric(horizontal: lg, vertical: md);

  // Border Radius (from web theme.css)
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 20.0;
  static const double radiusXl2 = 24.0;
  static const double radiusFull = 9999.0; // Full circle

  // BorderRadius Presets
  static BorderRadius borderRadiusXs = BorderRadius.circular(radiusXs);
  static BorderRadius borderRadiusSm = BorderRadius.circular(radiusSm);
  static BorderRadius borderRadiusMd = BorderRadius.circular(radiusMd);
  static BorderRadius borderRadiusLg = BorderRadius.circular(radiusLg);
  static BorderRadius borderRadiusXl = BorderRadius.circular(radiusXl);
  static BorderRadius borderRadiusXl2 = BorderRadius.circular(radiusXl2);
  static BorderRadius borderRadiusFull = BorderRadius.circular(radiusFull);

  // Icon Sizes
  static const double iconXs = 16.0;
  static const double iconSm = 20.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;
  static const double iconXl = 40.0;
  static const double iconXl2 = 48.0;
  static const double iconXl3 = 64.0;

  // Avatar Sizes
  static const double avatarSm = 32.0;
  static const double avatarMd = 40.0;
  static const double avatarLg = 48.0;
  static const double avatarXl = 64.0;
  static const double avatarXl2 = 80.0;
  static const double avatarXl3 = 100.0;

  // Button Heights
  static const double buttonHeightSm = 36.0;
  static const double buttonHeightMd = tap; // 44.0 (accessibility)
  static const double buttonHeightLg = 52.0;

  // Input/Field Heights
  static const double inputHeightSm = 36.0;
  static const double inputHeightMd = tap; // 44.0 (accessibility)
  static const double inputHeightLg = 52.0;

  // Divider/Border Widths
  static const double dividerThin = 1.0;
  static const double dividerMedium = 2.0;
  static const double dividerThick = 4.0;

  // App Bar Heights
  static const double appBarHeight = 56.0;
  static const double bottomNavBarHeight = 60.0;

  // List Tile Heights
  static const double listTileHeightSm = 48.0;
  static const double listTileHeightMd = 56.0;
  static const double listTileHeightLg = 72.0;

  // SizedBox Shortcuts (for gaps)
  static const SizedBox gapXs = SizedBox(width: xs, height: xs);
  static const SizedBox gapSm = SizedBox(width: sm, height: sm);
  static const SizedBox gapMd = SizedBox(width: md, height: md);
  static const SizedBox gapLg = SizedBox(width: lg, height: lg);
  static const SizedBox gapXl = SizedBox(width: xl, height: xl);
  static const SizedBox gapXl2 = SizedBox(width: xl2, height: xl2);

  // Horizontal Gaps
  static const SizedBox gapHorizontalXs = SizedBox(width: xs);
  static const SizedBox gapHorizontalSm = SizedBox(width: sm);
  static const SizedBox gapHorizontalMd = SizedBox(width: md);
  static const SizedBox gapHorizontalLg = SizedBox(width: lg);
  static const SizedBox gapHorizontalXl = SizedBox(width: xl);

  // Vertical Gaps
  static const SizedBox gapVerticalXs = SizedBox(height: xs);
  static const SizedBox gapVerticalSm = SizedBox(height: sm);
  static const SizedBox gapVerticalMd = SizedBox(height: md);
  static const SizedBox gapVerticalLg = SizedBox(height: lg);
  static const SizedBox gapVerticalXl = SizedBox(height: xl);
}
