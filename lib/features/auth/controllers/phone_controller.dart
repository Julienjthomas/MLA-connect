import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import 'auth_controller.dart';

class PhoneController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final RxBool loading = false.obs;

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }

  Future<void> sendOtp() async {
    if (!formKey.currentState!.validate()) return;
    loading.value = true;
    try {
      await Get.find<AuthController>().sendOtp(phoneController.text.trim());
      Get.toNamed(Routes.otp, arguments: phoneController.text.trim());
    } catch (_) {
      Get.snackbar(
        'Error',
        'Failed to send OTP. Please try again.',
        backgroundColor: const Color(0xFFB00020),
        colorText: const Color(0xFFFFFFFF),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      loading.value = false;
    }
  }
}
