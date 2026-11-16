import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {
  static bool _isInitialized = false;

  static Future<void> initialize() async {
    if (kIsWeb) return;
    try {
      await MobileAds.instance.initialize();
      _isInitialized = true;
    } catch (e) {
      debugPrint('AdMob baslatma hatasi: $e');
    }
  }

  static bool get isInitialized => _isInitialized;

  // Google Resmi Test Banner Reklam Birimi Kimlikleri
  static String get bannerAdUnitId {
    if (kIsWeb) return '';
    if (Platform.isAndroid) {
      // Android Test Banner ID
      return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      // iOS Test Banner ID
      return 'ca-app-pub-3940256099942544/2934735716';
    }
    return '';
  }
}
