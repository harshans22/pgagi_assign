import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppConstants {
  // App Information
  static const String appName = 'StartupHub';
  static const String appVersion = '1.0.0';

  // Storage Keys
  static const String ideasKey = 'startup_ideas';
  static const String votedIdeasKey = 'voted_ideas';
  static const String darkModeKey = 'dark_mode';

  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 300);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 500);
  static const Duration longAnimationDuration = Duration(milliseconds: 800);

  // Spacing
  static const double smallSpacing = 8.0;
  static const double mediumSpacing = 16.0;
  static const double largeSpacing = 24.0;
  static const double extraLargeSpacing = 32.0;

  // Border Radius
  static const double smallRadius = 8.0;
  static const double mediumRadius = 12.0;
  static const double largeRadius = 16.0;
  static const double extraLargeRadius = 24.0;
}

class AppColors {
  // Light Theme Colors
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryVariant = Color(0xFF5A52E8);
  static const Color secondary = Color(0xFFFF6B6B);
  static const Color secondaryVariant = Color(0xFFE85555);

  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F3F4);

  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onBackground = Color(0xFF1A1A1A);
  static const Color onSurface = Color(0xFF1A1A1A);

  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);

  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint = Color(0xFF9CA3AF);

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF0D1117);
  static const Color darkSurface = Color(0xFF161B22);
  static const Color darkSurfaceVariant = Color(0xFF21262D);

  static const Color darkOnBackground = Color(0xFFE6EDF3);
  static const Color darkOnSurface = Color(0xFFE6EDF3);
  static const Color darkTextPrimary = Color(0xFFE6EDF3);
  static const Color darkTextSecondary = Color(0xFF8B949E);
  static const Color darkTextHint = Color(0xFF6E7681);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryVariant],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryVariant],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient silverGradient = LinearGradient(
    colors: [Color(0xFFC0C0C0), Color(0xFF808080)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient bronzeGradient = LinearGradient(
    colors: [Color(0xFFCD7F32), Color(0xFF8B4513)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppTextStyles {
  static TextStyle get heading1 => GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );

  static TextStyle get heading2 => GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static TextStyle get heading3 => GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static TextStyle get subtitle1 => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  static TextStyle get subtitle2 => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  static TextStyle get body1 => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  static TextStyle get body2 => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  static TextStyle get caption => GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.4,
  );

  static TextStyle get button => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );
}
