import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import 'auth_controller.dart';

class OtpController extends GetxController {
  final otpController = TextEditingController();
  final RxBool loading = false.obs;
  final RxInt resendSeconds = 25.obs;
  late final String phone;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    phone = Get.arguments as String? ?? '';
    _startTimer();
  }

  @override
  void onClose() {
    otpController.dispose();
    _timer?.cancel();
    super.onClose();
  }

  void _startTimer() {
    resendSeconds.value = 25;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      resendSeconds.value--;
      if (resendSeconds.value <= 0) t.cancel();
    });
  }

  Future<void> resend() async {
    await Get.find<AuthController>().sendOtp(phone);
    _startTimer();
  }

  Future<void> verify() async {
    if (otpController.text.length != 6) return;
    loading.value = true;
    try {
      final auth = Get.find<AuthController>();
      final success = await auth.verifyOtp(phone, otpController.text);
      if (success) {
        final hasProfile = await auth.hasCompletedOnboarding();
        Get.offAllNamed(hasProfile ? Routes.home : Routes.panchayat);
      } else {
        Get.snackbar(
          'Invalid OTP',
          'Please check the code and try again.',
          backgroundColor: const Color(0xFFB00020),
          colorText: const Color(0xFFFFFFFF),
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (_) {
      Get.snackbar('Error', 'Verification failed. Please try again.', snackPosition: SnackPosition.BOTTOM);
    } finally {
      loading.value = false;
    }
  }
}
