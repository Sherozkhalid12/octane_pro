import 'package:flutter/material.dart';
import 'dart:ui';

/// OctanePro Futuristic Design System
/// Dark-mode-first, Premium, High-tech
/// Primary: Red, Secondary: Black, Accent: White
class AppTheme {
  // ========== PRIMARY COLORS - RED (Professional) ==========
  static const Color primaryRed = Color(0xFFDC2626); // Professional Red
  static const Color primaryRedDark = Color(0xFFB91C1C); // Dark Red
  static const Color primaryRedLight = Color(0xFFEF4444); // Light Red
  static const Color primaryRedGlow = Color(0xFFDC2626); // Glowing Red
  static const Color primaryRedLighter = Color(0xFFF87171); // Lighter Red

  // ========== SECONDARY COLORS - BLACK ==========
  static const Color secondaryBlack = Color(0xFF000000); // Pure Black
  static const Color secondaryBlackLight = Color(0xFF0A0A0A); // Near Black
  static const Color secondaryBlackLighter = Color(0xFF1A1A1A); // Dark Gray
  static const Color secondaryBlackAccent = Color(0xFF2A2A2A); // Lighter Dark

  // ========== BACKGROUND COLORS - WHITE FIRST ==========
  static const Color backgroundWhite = Color(0xFFFFFFFF); // Pure White Background
  static const Color backgroundWhiteSoft = Color(0xFFFAFAFA); // Soft White
  static const Color backgroundGray = Color(0xFFF5F5F5); // Light Gray Background
  static const Color backgroundGrayLight = Color(0xFFF0F0F0); // Lighter Gray
  
  // Minimal black for contrast
  static const Color backgroundDark = Color(0xFF1A1A1A); // Minimal Black (not totally black)
  static const Color backgroundDarkElevated = Color(0xFF2A2A2A); // Elevated Dark
  static const Color backgroundDarkSurface = Color(0xFF333333); // Surface Dark
  static const Color backgroundDarkCard = Color(0xFF2A2A2A); // Card Dark

  // ========== ACCENT COLORS - WHITE ==========
  static const Color accentWhite = Color(0xFFFFFFFF); // Pure White
  static const Color accentWhiteDim = Color(0xFFF5F5F5); // Dim White
  static const Color accentWhiteSoft = Color(0xFFE5E5E5); // Soft White

  // ========== TEXT COLORS ==========
  static const Color textPrimary = Color(0xFF1A1A1A); // Black Text (on white)
  static const Color textSecondary = Color(0xFF666666); // Gray Text
  static const Color textTertiary = Color(0xFF999999); // Light Gray Text
  static const Color textDisabled = Color(0xFFCCCCCC); // Disabled Text
  static const Color textOnRed = Color(0xFFFFFFFF); // White Text on Red

  // ========== STATUS COLORS - Professional & Muted ==========
  static const Color successGreen = Color(0xFF10B981); // Professional Green
  static const Color successGreenGlow = Color(0xFF10B981);
  static const Color successGreenDark = Color(0xFF059669);
  static const Color errorRed = Color(0xFFEF4444); // Professional Red
  static const Color errorRedGlow = Color(0xFFEF4444);
  static const Color warningYellow = Color(0xFFF59E0B); // Professional Amber
  static const Color warningYellowGlow = Color(0xFFF59E0B);
  static const Color infoBlue = Color(0xFF3B82F6); // Professional Blue
  static const Color infoBlueGlow = Color(0xFF3B82F6);

  // ========== BORDER COLORS ==========
  static const Color borderGray = Color(0xFFE0E0E0); // Light Gray Border
  static const Color borderGrayLight = Color(0xFFF0F0F0); // Lighter Gray Border
  static const Color borderRed = Color(0xFFE63946); // Red Border
  static const Color borderGlow = Color(0xFFE63946); // Glowing Red Border
  static const Color borderDark = Color(0xFF333333); // Dark Border (for dark cards)

  // ========== COMPATIBILITY COLORS (for existing code) ==========
  // Light variants for status colors (with opacity)
  static Color get successGreenLight => successGreen.withOpacity(0.15);
  static Color get errorRedLight => errorRed.withOpacity(0.15);
  static Color get warningYellowLight => warningYellow.withOpacity(0.15);
  static Color get infoBlueLight => infoBlue.withOpacity(0.15);

  // ========== TYPOGRAPHY ==========
  static const String fontFamily = 'Roboto';
  static const String fontFamilyDisplay = 'Roboto'; // Can be changed to a futuristic font
  
  // ========== GLASSMORPHISM ==========
  static Color get glassBackground => Colors.white.withOpacity(0.9);
  static Color get glassBackgroundElevated => Colors.white.withOpacity(0.95);
  static Color get glassBorder => primaryRed.withOpacity(0.2);
  
  // ========== GRADIENTS ==========
  static LinearGradient get redGradient => LinearGradient(
    colors: [primaryRed, primaryRedLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static LinearGradient get redGradientGlow => LinearGradient(
    colors: [primaryRedGlow, primaryRedLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static LinearGradient get darkGradient => LinearGradient(
    colors: [backgroundDark, backgroundDarkElevated],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static LinearGradient get cardGradient => LinearGradient(
    colors: [backgroundWhite, backgroundWhiteSoft],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static LinearGradient get whiteGradient => LinearGradient(
    colors: [backgroundWhite, backgroundGray],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // ========== GLOW EFFECTS - Professional Subtle Shadows ==========
  static List<BoxShadow> get redGlow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 12,
      spreadRadius: 0,
      offset: const Offset(0, 2),
    ),
    BoxShadow(
      color: primaryRed.withOpacity(0.06),
      blurRadius: 8,
      spreadRadius: 0,
      offset: const Offset(0, 1),
    ),
  ];
  
  static List<BoxShadow> get redGlowStrong => [
    BoxShadow(
      color: Colors.black.withOpacity(0.12),
      blurRadius: 16,
      spreadRadius: 0,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: primaryRed.withOpacity(0.08),
      blurRadius: 12,
      spreadRadius: 0,
      offset: const Offset(0, 2),
    ),
  ];
  
  static List<BoxShadow> get cardGlow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.06),
      blurRadius: 8,
      spreadRadius: 0,
      offset: const Offset(0, 2),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      blurRadius: 4,
      spreadRadius: 0,
      offset: const Offset(0, 1),
    ),
  ];

  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;

  // ========== BORDER RADIUS ==========
  static const double radiusS = 6.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusXXL = 32.0;
  static const double radiusRound = 999.0;

  // ========== SHADOWS - Professional & Subtle ==========
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 8,
          spreadRadius: 0,
          offset: const Offset(0, 2),
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 4,
          spreadRadius: 0,
          offset: const Offset(0, 1),
        ),
      ];

  static List<BoxShadow> get cardShadowElevated => [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 12,
          spreadRadius: 0,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 6,
          spreadRadius: 0,
          offset: const Offset(0, 2),
        ),
      ];
  
  static List<BoxShadow> get buttonShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 8,
          spreadRadius: 0,
          offset: const Offset(0, 2),
        ),
        BoxShadow(
          color: primaryRed.withOpacity(0.15),
          blurRadius: 6,
          spreadRadius: 0,
          offset: const Offset(0, 1),
        ),
      ];

  // Animation Durations
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationMedium = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  /// Light Theme (Primary - Futuristic White/Red)
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: primaryRed,
        secondary: secondaryBlack,
        surface: backgroundWhite,
        background: backgroundGray,
        error: errorRed,
        onPrimary: accentWhite,
        onSecondary: accentWhite,
        onSurface: textPrimary,
        onBackground: textPrimary,
        onError: accentWhite,
      ),
      scaffoldBackgroundColor: backgroundGray,
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundWhite,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          fontFamily: fontFamily,
          letterSpacing: 0.5,
        ),
        iconTheme: const IconThemeData(
          color: textPrimary,
          size: 24,
        ),
        shadowColor: primaryRed.withOpacity(0.1),
      ),
      cardTheme: CardThemeData(
        color: backgroundWhite,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusXL),
          side: BorderSide(color: borderGray, width: 1),
        ),
        margin: const EdgeInsets.all(spacingM),
        shadowColor: primaryRed.withOpacity(0.1),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: backgroundWhite,
        hintStyle: const TextStyle(color: textTertiary),
        labelStyle: const TextStyle(color: textSecondary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: BorderSide(color: borderGray, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: BorderSide(color: borderGray, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: BorderSide(color: primaryRed, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: BorderSide(color: errorRed, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: BorderSide(color: errorRed, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacingM,
          vertical: spacingM,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryRed,
          foregroundColor: accentWhite,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: spacingL,
            vertical: spacingM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusM),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: fontFamily,
            letterSpacing: 0.5,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryRed,
          padding: const EdgeInsets.symmetric(
            horizontal: spacingM,
            vertical: spacingS,
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontFamily: fontFamily,
            letterSpacing: 0.3,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryRed,
          side: BorderSide(color: primaryRed, width: 2),
          padding: const EdgeInsets.symmetric(
            horizontal: spacingL,
            vertical: spacingM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusM),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: fontFamily,
            letterSpacing: 0.5,
          ),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: textPrimary,
          fontFamily: fontFamily,
          letterSpacing: -0.5,
        ),
        displayMedium: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textPrimary,
          fontFamily: fontFamily,
          letterSpacing: -0.5,
        ),
        displaySmall: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: textPrimary,
          fontFamily: fontFamily,
          letterSpacing: 0,
        ),
        headlineLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: textPrimary,
          fontFamily: fontFamily,
          letterSpacing: 0,
        ),
        headlineMedium: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: textPrimary,
          fontFamily: fontFamily,
          letterSpacing: 0.25,
        ),
        headlineSmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textPrimary,
          fontFamily: fontFamily,
          letterSpacing: 0.25,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: textPrimary,
          fontFamily: fontFamily,
          letterSpacing: 0.25,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          fontFamily: fontFamily,
          letterSpacing: 0.25,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          fontFamily: fontFamily,
          letterSpacing: 0.25,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: textPrimary,
          fontFamily: fontFamily,
          letterSpacing: 0.25,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: textPrimary,
          fontFamily: fontFamily,
          letterSpacing: 0.25,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: textSecondary,
          fontFamily: fontFamily,
          letterSpacing: 0.25,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          fontFamily: fontFamily,
          letterSpacing: 0.5,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textSecondary,
          fontFamily: fontFamily,
          letterSpacing: 0.5,
        ),
        labelSmall: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: textTertiary,
          fontFamily: fontFamily,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
  
  /// Dark Theme (Fallback - Minimal Black)
  static ThemeData get darkTheme => lightTheme;
}
