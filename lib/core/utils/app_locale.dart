import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppLocale {
  AppLocale._();

  static void change(String languageCode) {
    Get.updateLocale(Locale(languageCode));
  }

  static String get current => Get.locale?.languageCode ?? 'en';

  static bool get isMalayalam => current == 'ml';
}
