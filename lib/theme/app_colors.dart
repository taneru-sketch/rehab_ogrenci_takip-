import 'package:flutter/material.dart';

/// Uygulamanın renk paleti — sıcak, mutlu edici, erişilebilir
class AppColors {
  // Ana renkler
  static const Color primary      = Color(0xFF7C3AED); // Soft Violet/Mor
  static const Color secondary    = Color(0xFFF59E0B); // Warm Amber/Sarı
  static const Color accent       = Color(0xFF10B981); // Mint Yeşil
  static const Color coral        = Color(0xFFFF6B6B); // Coral/Mercan (uyarı)
  static const Color sky          = Color(0xFF38BDF8); // Sky Blue

  // Arka plan
  static const Color background   = Color(0xFFFFFBF5); // Sıcak Krem
  static const Color cardBg       = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFF5F0FF); // Açık mor yüzey

  // Kritik kart renkleri
  static const Color criticalBg   = Color(0xFFFFF1F2);
  static const Color criticalBorder = Color(0xFFFFB3B3);

  static const Color toiletBg     = Color(0xFFE0F2FE);
  static const Color medicationBg = Color(0xFFECFDF5);
  static const Color schoolBg     = Color(0xFFF3E8FF);
  static const Color behaviorBg   = Color(0xFFFFFBEB);

  // Gradientler
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF7C3AED), Color(0xFF5B21B6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient sunsetGradient = LinearGradient(
    colors: [Color(0xFFFF6B6B), Color(0xFFFECA57)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient mintGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF059669)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient skyGradient = LinearGradient(
    colors: [Color(0xFF38BDF8), Color(0xFF0EA5E9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Avatar renk paleti (öğrenci listesinde sırayla kullanılır)
  static const List<Color> avatarColors = [
    Color(0xFF7C3AED),
    Color(0xFF10B981),
    Color(0xFFFF6B6B),
    Color(0xFFF59E0B),
    Color(0xFF38BDF8),
    Color(0xFFEC4899),
    Color(0xFF8B5CF6),
    Color(0xFF06B6D4),
  ];
}
