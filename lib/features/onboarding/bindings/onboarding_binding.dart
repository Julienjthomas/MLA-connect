import 'package:get/get.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<OnboardingController>()) {
      Get.put<OnboardingController>(OnboardingController(), permanent: true);
    }
  }
}
