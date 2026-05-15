import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../constants/constituency_seed.dart';

abstract class AppIconService {
  static const _channel = MethodChannel('systems.keyvalue.super_balussery/app_icon');

  static const _slugToIosIcon = {
    ConstituencySeed.balusserySlug: 'balussery',
    ConstituencySeed.koduvalliSlug: 'koduvalli',
    ConstituencySeed.perambraSlug: 'perambra',
  };

  static const _slugToAndroidAlias = {
    ConstituencySeed.balusserySlug: 'BalusseryAlias',
    ConstituencySeed.koduvalliSlug: 'KoduvalliAlias',
    ConstituencySeed.perambraSlug: 'PerambraAlias',
  };

  // Android: switching alias while foregrounded kills the active task (the task was
  // launched under the current alias component). Defer until app goes to background.
  static String? _pendingAndroidSlug;
  static bool _hasPendingAndroid = false;

  static Future<void> setForConstituency(String? slug) async {
    if (slug == null || slug.isEmpty) {
      await clearToDefault();
      return;
    }
    if (!ConstituencySeed.knownSlugs.contains(slug)) {
      debugPrint('[AppIconService] Unknown slug "$slug" — falling back to default icon.');
      await clearToDefault();
      return;
    }
    if (Platform.isAndroid) {
      if (_androidAliasesSupported) {
        _pendingAndroidSlug = slug;
        _hasPendingAndroid = true;
      }
      return;
    }
    try {
      await _channel.invokeMethod('setIcon', {'icon': _slugToIosIcon[slug]});
    } catch (e) {
      debugPrint('[AppIconService] Failed to set icon for slug "$slug": $e');
    }
  }

  static Future<void> clearToDefault() async {
    if (Platform.isAndroid) {
      if (_androidAliasesSupported) {
        _pendingAndroidSlug = null;
        _hasPendingAndroid = true;
      }
      return;
    }
    try {
      if (Platform.isIOS) {
        await _channel.invokeMethod('setIcon', {'icon': null});
      }
    } catch (e) {
      debugPrint('[AppIconService] Failed to clear icon: $e');
    }
  }

  /// Debug/profile manifests omit activity-alias launchers; icon switch is release-only.
  static bool get _androidAliasesSupported =>
      !kDebugMode && !kProfileMode;

  /// Apply pending Android alias switch. Call from AppLifecycleListener.onPause.
  static Future<void> applyPendingAndroid() async {
    if (!Platform.isAndroid || !_hasPendingAndroid || !_androidAliasesSupported) {
      return;
    }
    _hasPendingAndroid = false;
    final slug = _pendingAndroidSlug;
    try {
      final alias = slug != null ? _slugToAndroidAlias[slug] : null;
      await _channel.invokeMethod('setIcon', {'alias': alias});
    } catch (e) {
      debugPrint('[AppIconService] Failed to apply pending Android icon: $e');
    }
  }
}
