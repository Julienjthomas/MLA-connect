import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/services/app_config_service.dart';
import '../screens/force_update_screen.dart';
import '../screens/maintenance_screen.dart';

/// Wraps the entire app content. Overlays [ForceUpdateScreen] or
/// [MaintenanceScreen] reactively whenever [AppConfigService] flags change.
///
/// Used in [GetMaterialApp]'s `builder`:
/// ```dart
/// builder: (context, child) => AppConfigWrapper(child: child!),
/// ```
class AppConfigWrapper extends StatelessWidget {
  const AppConfigWrapper({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AppConfigService>()) return child;
    final service = Get.find<AppConfigService>();

    return Obx(() {
      if (service.forceUpdate.value) {
        return const ForceUpdateScreen();
      }
      if (service.maintenanceMode.value) {
        return const MaintenanceScreen();
      }
      return child;
    });
  }
}
