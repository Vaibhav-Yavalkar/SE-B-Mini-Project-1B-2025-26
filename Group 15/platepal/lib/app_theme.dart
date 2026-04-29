// lib/app_theme.dart

import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors
  static const Color primary = Color(0xFF2D6A4F);       // Deep forest green
  static const Color primaryLight = Color(0xFF52B788);  // Fresh leaf green
  static const Color primaryDark = Color(0xFF1B4332);   // Dark pine
  static const Color accent = Color(0xFFFF7043);        // Warm orange
  static const Color accentLight = Color(0xFFFFAB91);   // Soft peach
  static const Color background = Color(0xFFF8F9F4);    // Off-white with green tint
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF0F4EF);
  static const Color textPrimary = Color(0xFF1A2E1F);   // Near black green
  static const Color textSecondary = Color(0xFF5C7060); // Muted green grey
  static const Color textLight = Color(0xFF9DB4A0);
  static const Color error = Color(0xFFE53935);
  static const Color success = Color(0xFF43A047);
  static const Color warning = Color(0xFFFFB300);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color divider = Color(0xFFE8EDE9);

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Nunito',
      colorScheme: ColorScheme.light(
        primary: primary,
        secondary: accent,
        surface: surface,
        background: background,
        error: error,
      ),
      scaffoldBackgroundColor: background,
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: textPrimary,
        titleTextStyle: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: textPrimary,
          letterSpacing: -0.3,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: divider, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(color: textLight),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceVariant,
        labelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textSecondary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        side: BorderSide.none,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primary,
        unselectedItemColor: textLight,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
