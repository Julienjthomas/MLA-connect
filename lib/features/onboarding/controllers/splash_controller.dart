import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../../routes/app_routes.dart';

class SplashController extends GetxController with GetSingleTickerProviderStateMixin {
  late final AnimationController animController;
  late final Animation<double> fadeAnim;
  late final Animation<double> scaleAnim;

  @override
  void onInit() {
    super.onInit();
    animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    fadeAnim = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: animController, curve: Curves.easeOut));
    scaleAnim = Tween<double>(
      begin: 0.85,
      end: 1,
    ).animate(CurvedAnimation(parent: animController, curve: Curves.easeOut));
    animController.forward();
    _navigate();
  }

  @override
  void onClose() {
    animController.dispose();
    super.onClose();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 2000));
    final auth = Get.find<AuthController>();
    if (auth.isLoggedIn) {
      final hasProfile = await auth.hasCompletedOnboarding();
      Get.offAllNamed(hasProfile ? Routes.home : Routes.panchayat);
    } else {
      Get.offAllNamed(Routes.welcome);
    }
  }
}
