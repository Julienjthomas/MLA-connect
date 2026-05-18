import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../activity/views/activity_view.dart';
import '../../home/views/home_view.dart';
import '../../profile/views/profile_view.dart';
import '../../updates/views/updates_view.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/app_locale.dart';
import '../controllers/shell_controller.dart';

class MainShellView extends GetView<ShellController> {
  const MainShellView({super.key});

  static const _navIconSize = 24.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        AppLocale.languageCode.value;
        return IndexedStack(
          index: controller.currentIndex.value,
          children: const [
            HomeView(),
            ActivityView(),
            UpdatesView(),
            ProfileView(),
          ],
        );
      }),
      bottomNavigationBar: Obx(() {
        AppLocale.languageCode.value;
        return NavigationBar(
          height: 80,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          selectedIndex: controller.currentIndex.value,
          onDestinationSelected: controller.goTo,
          destinations: [
            _dest(Icons.home_outlined, Icons.home_rounded, AppStrings.navHome),
            _dest(Icons.bar_chart_outlined, Icons.bar_chart_rounded, AppStrings.navActivity),
            _dest(Icons.article_outlined, Icons.article_rounded, AppStrings.navUpdates),
            _dest(Icons.person_outline_rounded, Icons.person_rounded, AppStrings.navProfile),
          ],
        );
      }),
    );
  }

  NavigationDestination _dest(IconData icon, IconData activeIcon, String label) {
    return NavigationDestination(
      icon: _navIcon(icon),
      selectedIcon: _navIcon(activeIcon),
      label: label,
    );
  }

  Widget _navIcon(IconData icon) {
    return SizedBox(
      width: _navIconSize,
      height: _navIconSize,
      child: Icon(icon, size: _navIconSize),
    );
  }
}
