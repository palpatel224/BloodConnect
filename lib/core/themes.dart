import 'package:flutter/material.dart';

/// App-wide theme configuration and design system
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // ========== COLORS ==========

  /// Primary red color - main brand color
  static const Color primaryRed = Color(0xFFD32F2F);

  /// Light red color - for backgrounds and light accents
  static const Color primaryRedLight = Color(0xFFFEE8E8);

  /// Success green color
  static const Color successGreen = Color(0xFF4CAF50);

  /// Success green background
  static const Color successGreenLight = Color(0xFFE8F5E8);

  /// Warning orange color
  static const Color warningOrange = Color(0xFFFF9800);

  /// Warning orange background
  static const Color warningOrangeLight = Color(0xFFFFF3E0);

  /// Error color (same as primary red for consistency)
  static const Color errorRed = primaryRed;

  /// Error background
  static const Color errorRedLight = primaryRedLight;

  /// Neutral colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Color(0xFF9E9E9E);

  /// Background colors
  static const Color backgroundColor = Color(0xFFFAFAFA);
  static const Color cardBackground = Colors.white;
  static const Color inputBackground = Color(0xFFF5F5F5);

  // ========== SPACING ==========

  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacingXxl = 48.0;

  // ========== BORDER RADIUS ==========

  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 20.0;

  // ========== SHADOWS ==========

  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get buttonShadow => [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 1,
          blurRadius: 3,
          offset: const Offset(0, 1),
        ),
      ];

  // ========== TEXT STYLES ==========

  static const TextStyle headingLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );

  static const TextStyle headingMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );

  static const TextStyle headingSmall = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: textPrimary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: textSecondary,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: textLight,
  );

  // ========== BUTTON STYLES ==========

  static ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
        backgroundColor: primaryRed,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: spacingLg,
          vertical: spacingMd,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
        ),
        elevation: 2,
      );

  static ButtonStyle get secondaryButtonStyle => OutlinedButton.styleFrom(
        foregroundColor: primaryRed,
        side: const BorderSide(color: primaryRed),
        padding: const EdgeInsets.symmetric(
          horizontal: spacingLg,
          vertical: spacingMd,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
        ),
      );

  // ========== INPUT DECORATION ==========

  static InputDecoration get inputDecoration => InputDecoration(
        filled: true,
        fillColor: inputBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: primaryRed),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacingMd,
          vertical: spacingMd,
        ),
      );

  // ========== STATUS COLORS ==========

  /// Get color for pending status
  static Color get pendingColor => warningOrange;
  static Color get pendingBackgroundColor => warningOrangeLight;

  /// Get color for approved/success status
  static Color get approvedColor => successGreen;
  static Color get approvedBackgroundColor => successGreenLight;

  /// Get color for rejected/error status
  static Color get rejectedColor => errorRed;
  static Color get rejectedBackgroundColor => errorRedLight;

  // ========== COMPONENT THEMES ==========

  /// Theme for blood type chips
  static BoxDecoration get bloodTypeChipDecoration => BoxDecoration(
        color: primaryRedLight,
        borderRadius: BorderRadius.circular(radiusXl),
      );

  static TextStyle get bloodTypeChipTextStyle => const TextStyle(
        color: primaryRed,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      );
}

/// Extension methods for easy access to theme properties
extension AppThemeExtension on BuildContext {
  /// Quick access to primary color
  Color get primaryColor => AppTheme.primaryRed;

  /// Quick access to text styles
  TextStyle get headingLarge => AppTheme.headingLarge;
  TextStyle get headingMedium => AppTheme.headingMedium;
  TextStyle get headingSmall => AppTheme.headingSmall;
  TextStyle get bodyLarge => AppTheme.bodyLarge;
  TextStyle get bodyMedium => AppTheme.bodyMedium;
  TextStyle get bodySmall => AppTheme.bodySmall;
  TextStyle get caption => AppTheme.caption;
}
