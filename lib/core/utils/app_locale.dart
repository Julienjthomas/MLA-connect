import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLocale {
  AppLocale._();

  static const _storageKey = 'app_locale';
  static final RxString languageCode = 'en'.obs;

  static void change(String code) {
    languageCode.value = code;
    Get.updateLocale(Locale(code));
    SharedPreferences.getInstance().then((prefs) => prefs.setString(_storageKey, code));
  }

  static String get current => languageCode.value;

  static bool get isMalayalam => current == 'ml';

  static Future<bool> hasStoredPreference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_storageKey);
  }

  static Future<String> load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_storageKey);
    if (code != null) {
      languageCode.value = code;
      return code;
    }
    return 'en';
  }
}
