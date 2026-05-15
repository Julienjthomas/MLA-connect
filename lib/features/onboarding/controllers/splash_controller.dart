import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/constituency_prefs.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../../routes/app_routes.dart';

class SplashController extends GetxController with GetSingleTickerProviderStateMixin {
  late final AnimationController animController;
  late final Animation<double> fadeAnim;
  late final Animation<double> scaleAnim;
  final RxString constituencyName = ''.obs;

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

  Future<void> _loadConstituencyName(AuthController auth) async {
    final profileName = auth.user.value?.constituencyName;
    if (profileName != null && profileName.isNotEmpty) {
      constituencyName.value = profileName;
      return;
    }
    final savedName = await ConstituencyPrefs.getName();
    if (savedName != null && savedName.isNotEmpty) {
      constituencyName.value = savedName;
    }
  }

  @override
  void onClose() {
    animController.dispose();
    super.onClose();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 2000));
    final auth = Get.find<AuthController>();

    // Bootstrap: fetch full citizen profile before making any routing decision.
    await auth.bootstrapSession();

    await _loadConstituencyName(auth);

    if (!auth.isLoggedIn) {
      Get.offAllNamed(Routes.welcome);
      return;
    }

    final hasProfile = await auth.hasCompletedOnboarding();

    // Consume any stale pending return route for fully-onboarded users.
    final pendingRoute = await ConstituencyPrefs.getPendingReturnRoute();
    if (pendingRoute != null) {
      await ConstituencyPrefs.clearPendingReturnRoute();
    }

    if (hasProfile) {
      Get.offAllNamed(Routes.home);
    } else {
      // resolveOnboardingResumeRoute also consumes pendingReturnRoute if set,
      // but we already cleared it above for fully-onboarded users. For partial
      // users the pending route is intentionally consumed inside resolveOnboardingResumeRoute.
      // Re-save it so resolveOnboardingResumeRoute can pick it up.
      if (pendingRoute != null) {
        await ConstituencyPrefs.savePendingReturnRoute(pendingRoute);
      }
      final route = await auth.resolveOnboardingResumeRoute();
      Get.offAllNamed(route);
    }
  }
}
