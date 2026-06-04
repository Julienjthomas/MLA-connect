import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Fetches and holds remote app configuration.
///
/// Register once at startup:
///   await Get.putAsync(() => AppConfigService().init());
///
/// Re-fetches on every app resume so flags stay fresh without a restart.
class AppConfigService extends GetxService with WidgetsBindingObserver {
  // Feature flags — reactive so UI rebuilds automatically when values change.
  final RxBool maintenanceMode = false.obs;
  final RxBool forceUpdate = false.obs;
  final RxBool leaderboardEnabled = false.obs;
  final RxBool conversationsEnabled = true.obs;

  Dio get _dio => Get.find<Dio>();

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _fetch();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _fetch();
  }

  Future<void> _fetch() async {
    try {
      final resp = await _dio.get('/app-config');
      final body = resp.data;
      if (body is! Map<String, dynamic>) return;
      final data = (body['data'] ?? body) as Map<String, dynamic>;
      _apply(data);
    } catch (_) {
      // Network failure — keep current (or default) values.
    }
  }

  void _apply(Map<String, dynamic> data) {
    maintenanceMode.value = data['maintenance_mode'] as bool? ?? maintenanceMode.value;
    forceUpdate.value = data['force_update'] as bool? ?? forceUpdate.value;
    leaderboardEnabled.value = data['leaderboard_enabled'] as bool? ?? leaderboardEnabled.value;
    conversationsEnabled.value = data['conversations_enabled'] as bool? ?? conversationsEnabled.value;
  }
}
