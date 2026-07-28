import 'package:flutter/material.dart';

class AppColors {
  // Primary Brand Colors (Derived from logo plum)
  static const Color primary = Color(0xFFA64787);
  static const Color primaryDark = Color(0xFF6A1544);
  static const Color primaryLight = Color(0xFFF7EBF3);
  static const Color primaryGlow = Color(0x33A64787);

  // Secondary Brand Colors (Derived from logo green)
  static const Color secondary = Color(0xFF009846);
  static const Color secondaryDark = Color(0xFF006B31);
  static const Color secondaryLight = Color(0xFFE4F4EB);
  static const Color secondaryGlow = Color(0x33009846);

  // Accent & Highlight Colors
  static const Color accentGold = Color(0xFFFFB703);
  static const Color darkSurface = Color(0xFF1A1A22);

  // Neutral UI Colors
  static const Color background = Color(0xFFFAFAFD);
  static const Color surface = Colors.white;
  static const Color surfaceGlass = Color(0xCCFFFFFF);
  static const Color textPrimary = Color(0xFF1D1D21);
  static const Color textSecondary = Color(0xFF666670);
  static const Color border = Color(0xFFE8E8EE);
  static const Color borderGlass = Color(0x22A64787);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondary, secondaryDark],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFF9EEF5),
      Color(0xFFF4FAF6),
      Color(0xFFFAFAFD),
    ],
  );

  static const LinearGradient glassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xEEFFFFFF),
      Color(0xCCFFFFFF),
    ],
  );
}
