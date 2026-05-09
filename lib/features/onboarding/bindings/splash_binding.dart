import 'package:get/get.dart';

import '../controllers/splash_controller.dart';
import 'onboarding_binding.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashController());
    OnboardingBinding().dependencies();
  }
}

