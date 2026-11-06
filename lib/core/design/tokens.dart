import 'package:flutter/material.dart';

/// Approved design tokens. Do not hard-code colours/radii/blur elsewhere.
abstract final class AppColors {
  static const canvas = Color(0xFF000000);
  static const charcoal0 = Color(0xFF090909);
  static const charcoal1 = Color(0xFF161616);
  static const charcoal2 = Color(0xFF202020);
  static const charcoal3 = Color(0xFF292929);
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFFA0A0A0);
  static const accent = Color(0xFF8B6CF6); // Cool Purple (approved)

  // Reader backgrounds (spec section 8)
  static const readerBlack = Color(0xFF000000);
  static const readerGrey = Color(0xFF292929);
  static const readerWhite = Color(0xFFFFFFFF);
}

abstract final class AppRadii {
  static const double panel = 24; // major panels: 20-28 approved
  static const double card = 16; // cards: 14-20 approved
  static const double control = 12;
  static const double coverInset = 2; // cover radius = card - 2
  static BorderRadius get panelR => BorderRadius.circular(panel);
  static BorderRadius get cardR => BorderRadius.circular(card);
  static BorderRadius get controlR => BorderRadius.circular(control);
  static BorderRadius get coverR => BorderRadius.circular(card - coverInset);
}

abstract final class AppSpacing {
  static const double xs = 4, sm = 8, md = 12, lg = 16, xl = 24, xxl = 32;
  static const double floatingMargin = 16; // gap around floating nav
}

abstract final class AppMotion {
  static const fast = Duration(milliseconds: 150);
  static const base = Duration(milliseconds: 200);
  static const slow = Duration(milliseconds: 250);
  static const curve = Curves.easeOutCubic;
  static const double enterRise = 8;
}

/// Blur sigma / fill / border values approved in the design review.
abstract final class AppGlass {
  static const double panelSigma = 24;
  static const double cardSigma = 16;
  static const double panelFillAlpha = 0.06;
  static const double cardFillAlpha = 0.08;
  static const double borderTopLeftAlpha = 0.18;
  static const double borderBottomRightAlpha = 0.04;
  static const double innerHighlightAlpha = 0.06;
  // Used when GlassQuality.low (no blur): more opaque so text stays legible.
  static const double lowPanelFillAlpha = 0.14;
  static const double lowCardFillAlpha = 0.16;
  // Reader chrome: never blurred, even on High.
  static const double readerChromeFillAlpha = 0.82;

  static const panelShadow = [
    BoxShadow(color: Color(0x73000000), blurRadius: 32, offset: Offset(0, 12)),
  ];
  static const cardShadow = [
    BoxShadow(color: Color(0x73000000), blurRadius: 20, offset: Offset(0, 8)),
  ];
  static List<BoxShadow> accentGlow([double alpha = 0.20]) => [
    BoxShadow(color: AppColors.accent.withValues(alpha: alpha), blurRadius: 40),
  ];
}

abstract final class AppText {
  static const _f = 'Inter';
  static const _tab = [FontFeature.tabularFigures()];
  static const display = TextStyle(
    fontFamily: _f,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.15,
  );
  static const title = TextStyle(
    fontFamily: _f,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  static const body = TextStyle(
    fontFamily: _f,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );
  static const label = TextStyle(
    fontFamily: _f,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );
  static const numeric = TextStyle(
    fontFamily: _f,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    fontFeatures: _tab,
  );
}

ThemeData buildAppTheme() => ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  fontFamily: 'Inter',
  scaffoldBackgroundColor: AppColors.canvas,
  colorScheme: const ColorScheme.dark(
    primary: AppColors.accent,
    surface: AppColors.charcoal1,
    onSurface: AppColors.textPrimary,
  ),
  splashFactory: NoSplash.splashFactory,
);
