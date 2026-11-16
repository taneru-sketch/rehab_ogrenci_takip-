import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        tertiary: AppColors.accent,
        surface: AppColors.cardBg,
        primaryContainer: AppColors.surfaceLight,
      ),
      scaffoldBackgroundColor: AppColors.background,

      // Nunito — yuvarlak, sevimli, çocuk dostu font
      textTheme: GoogleFonts.nunitoTextTheme().copyWith(
        headlineLarge: GoogleFonts.nunito(fontWeight: FontWeight.w900),
        headlineMedium: GoogleFonts.nunito(fontWeight: FontWeight.w800),
        titleLarge: GoogleFonts.nunito(fontWeight: FontWeight.w800),
        titleMedium: GoogleFonts.nunito(fontWeight: FontWeight.w700),
        titleSmall: GoogleFonts.nunito(fontWeight: FontWeight.w700),
        bodyLarge: GoogleFonts.nunito(fontWeight: FontWeight.w500),
        bodyMedium: GoogleFonts.nunito(fontWeight: FontWeight.w500),
        labelLarge: GoogleFonts.nunito(fontWeight: FontWeight.w700),
      ),

      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF1E1B4B),
        titleTextStyle: GoogleFonts.nunito(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: const Color(0xFF1E1B4B),
        ),
      ),

      cardTheme: CardTheme(
        color: AppColors.cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF9F7FF),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE5E0FF)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE5E0FF)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        labelStyle: GoogleFonts.nunito(
          color: Colors.grey.shade600,
          fontWeight: FontWeight.w600,
        ),
        hintStyle: GoogleFonts.nunito(color: Colors.grey.shade400),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: GoogleFonts.nunito(
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
      ),

      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        labelStyle: GoogleFonts.nunito(fontWeight: FontWeight.w600, fontSize: 12),
      ),
    );
  }
}
