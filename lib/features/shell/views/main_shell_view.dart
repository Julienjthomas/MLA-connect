import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../activity/views/activity_view.dart';
import '../../home/views/home_view.dart';
import '../../profile/views/profile_view.dart';
import '../../updates/views/updates_view.dart';
import '../../../core/utils/app_locale.dart';
import '../controllers/shell_controller.dart';

class MainShellView extends GetView<ShellController> {
  const MainShellView({super.key});

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
      bottomNavigationBar: Obx(() => NavigationBar(
            selectedIndex: controller.currentIndex.value,
            onDestinationSelected: controller.goTo,
            destinations: [
              _dest(Icons.home_outlined, Icons.home_rounded, 'Home'),
              _dest(Icons.bar_chart_outlined, Icons.bar_chart_rounded, 'My Activity'),
              _dest(Icons.article_outlined, Icons.article_rounded, 'Updates'),
              _dest(Icons.person_outline_rounded, Icons.person_rounded, 'Profile'),
            ],
          )),
    );
  }

  NavigationDestination _dest(IconData icon, IconData activeIcon, String label) {
    return NavigationDestination(
      icon: Icon(icon),
      selectedIcon: Icon(activeIcon),
      label: label,
    );
  }
}
