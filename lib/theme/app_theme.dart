import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color background = Color(0xFF221710);
  static const Color surface = Color(0xFF14100E);
  static const Color cardColor = Color(0xFF191412);
  static const Color cardColorLight = Color(0xFF251D1A);
  static const Color primaryOrange = Color(0xFFFA7B1B);
  static const Color primaryOrangeLight = Color(0xFFFFA041);
  static const Color primaryOrangeDark = Color(0xFFC45E10);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFF9D928B);
  static const Color textTertiary = Color(0xFF5E534D);
  static const Color divider = Color(0xFF2C2521);
  static const Color success = Color(0xFF32D6C4);
  static const Color error = Color(0xFFE53935);
  static const Color tealBg = Color(0xFF102D2A);
  static const Color cyan = Color(0xFF28D8C4);
  static const Color blueTrack = Color(0xFF2B4F87);
  static const Color glow = Color(0xFF3A1E0E);

  static ThemeData get darkTheme {
    final baseTextTheme = ThemeData.dark().textTheme;
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: primaryOrange,
      fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
      textTheme: GoogleFonts.plusJakartaSansTextTheme(
        baseTextTheme,
      ).apply(bodyColor: textPrimary, displayColor: textPrimary),
      primaryTextTheme: GoogleFonts.plusJakartaSansTextTheme(
        ThemeData.dark().primaryTextTheme,
      ).apply(bodyColor: textPrimary, displayColor: textPrimary),
      colorScheme: const ColorScheme.dark(
        primary: primaryOrange,
        secondary: primaryOrangeLight,
        surface: surface,
        onPrimary: Colors.white,
        onSurface: textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
          color: textPrimary,
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(color: textPrimary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryOrange,
          foregroundColor: background,
          disabledBackgroundColor: primaryOrange.withValues(alpha: 0.2),
          disabledForegroundColor: Colors.white.withValues(alpha: 0.35),
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          textStyle: TextStyle(
            fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryOrange,
          side: const BorderSide(color: primaryOrange, width: 1.5),
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: TextStyle(
            fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryOrange,
          textStyle: TextStyle(
            fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardColorLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryOrange, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        hintStyle: TextStyle(
          fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
          color: textTertiary,
        ),
      ),
    );
  }
}
