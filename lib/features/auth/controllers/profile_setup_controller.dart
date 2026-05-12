import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../features/onboarding/controllers/onboarding_controller.dart';
import '../../../routes/app_routes.dart';
import 'auth_controller.dart';

class ProfileSetupController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final RxBool loading = false.obs;

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    super.onClose();
  }

  Future<void> next() async {
    if (!formKey.currentState!.validate()) return;
    loading.value = true;
    try {
      final onboarding = Get.find<OnboardingController>();
      final auth = Get.find<AuthController>();
      final language = auth.user.value?.language ?? 'en';
      await auth.saveProfile(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        constituencyId: onboarding.selectedConstituency.value?.id ?? auth.user.value?.constituencyId,
        localBodyId: onboarding.selectedLocalBody.value!.id,
        wardId: onboarding.selectedWard.value!.id,
        language: language,
      );
      Get.toNamed(Routes.notificationsSetup);
    } catch (_) {
      Get.snackbar('Error', 'Failed to save profile. Please try again.', snackPosition: SnackPosition.BOTTOM);
    } finally {
      loading.value = false;
    }
  }
}
