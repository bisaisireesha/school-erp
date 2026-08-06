import 'package:flutter/material.dart';

/// Single Unified Mobile Design System for Parent Portal
/// Mobile frame reference: 393 x 852 px (iPhone 15/16)
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;

  // Strict Global Contract Metrics
  static const double screenPadding = 16.0;
  static const double topSafeArea = 10.0;
  static const double sectionSpacing = 14.0;
  static const double cardSpacing = 12.0;
  static const double internalCardPadding = 12.0;
  static const double smallSpacing = 8.0;

  // Touch Targets & Heights
  static const double minTouchTarget = 48.0;
  static const double buttonHeight = 44.0;
  static const double inputHeight = 44.0;
  static const double headerHeight = 56.0;
  static const double bottomNavHeight = 76.0;

  // Header & Search Specific Spacing
  static const double logoSize = 38.0;
  static const double actionContainerSize = 38.0;
  static const double headerIconSize = 20.0;
  static const double badgeSize = 16.0;
  static const double logoTextGap = 10.0;
  static const double actionIconGap = 8.0;
  static const double headerBottomSpacing = 6.0;

  static const double searchBarHeight = 44.0;
  static const double searchBarRadius = 22.0;
  static const double searchIconSize = 18.0;
  static const double searchBarPaddingHorizontal = 14.0;
  static const double searchBarMarginTop = 6.0;
  static const double searchBarMarginBottom = 10.0;
  static const double cardPaddingHorizontal = 14.0;
}

class AppRadius {
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double card = 16.0;
  static const double pill = 24.0;
  static const double full = 999.0;
}

class AppTypography {
  static const TextStyle pageTitle = TextStyle(
    fontSize: 32.0,
    fontWeight: FontWeight.bold,
    color: Color(0xFF1E1E2D),
    letterSpacing: -0.5,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.w600,
    color: Color(0xFF1E1E2D),
  );

  static const TextStyle cardTitle = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    color: Color(0xFF1E1E2D),
  );

  static const TextStyle bodyText = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    color: Color(0xFF1E1E2D),
  );

  static const TextStyle secondaryText = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    color: Color(0xFF7A7A9D),
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
    color: Color(0xFF7A7A9D),
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  // Header Specific Typography
  static const TextStyle schoolName = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w700,
    color: Color(0xFF1E1E2D),
    letterSpacing: -0.3,
    height: 1.1,
  );

  static const TextStyle portalSubtitle = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
    color: Color(0xFF4A4A68),
  );
}

class AppShadows {
  static List<BoxShadow> soft = [
    BoxShadow(
      color: const Color(0xFF1E1E2D).withValues(alpha: 0.05),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> card = [
    BoxShadow(
      color: const Color(0xFF1E1E2D).withValues(alpha: 0.04),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];
}

/// Standardized Unified Back Button Component
/// Simple, minimal flat arrow — consistent across all Transport Portal screens.
class AppBackButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AppBackButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: AppSpacing.minTouchTarget,
        height: AppSpacing.minTouchTarget,
        child: Center(
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF1E1E2D),
            size: 19,
          ),
        ),
      ),
    );
  }
}
