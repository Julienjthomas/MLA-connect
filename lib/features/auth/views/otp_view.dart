import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/kerala_app_bar.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../routes/app_routes.dart';
import '../controllers/auth_controller.dart';

class OtpView extends StatefulWidget {
  const OtpView({super.key});

  @override
  State<OtpView> createState() => _OtpViewState();
}

class _OtpViewState extends State<OtpView> {
  final _otpController = TextEditingController();
  late final String phone;
  bool _loading = false;
  int _resendSeconds = 25;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    phone = Get.arguments as String? ?? '';
    _startTimer();
  }

  void _startTimer() {
    _resendSeconds = 25;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      setState(() { _resendSeconds--; if (_resendSeconds <= 0) t.cancel(); });
    });
  }

  @override
  void dispose() {
    _otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _verify() async {
    if (_otpController.text.length != 6) return;
    setState(() => _loading = true);
    try {
      final success = await Get.find<AuthController>().verifyOtp(phone, _otpController.text);
      if (success) {
        final hasProfile = await Get.find<AuthController>().hasCompletedOnboarding();
        if (hasProfile) {
          Get.offAllNamed(Routes.home);
        } else {
          Get.offAllNamed(Routes.panchayat);
        }
      } else {
        Get.snackbar('Invalid OTP', 'Please check the code and try again.',
            backgroundColor: AppColors.statusRejected, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
      }
    } catch (_) {
      Get.snackbar('Error', 'Verification failed. Please try again.',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultTheme = PinTheme(
      width: 52,
      height: 58,
      textStyle: AppTextStyles.headlineMedium,
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey300),
      ),
    );

    return Scaffold(
      appBar: const KeralaAppBar(title: ''),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              Text(AppStrings.verifyOtp, style: AppTextStyles.headlineLarge),
              const SizedBox(height: 8),
              Text(AppStrings.otpSentTo, style: AppTextStyles.bodyMedium),
              const SizedBox(height: 4),
              Row(children: [
                Text('+91 $phone', style: AppTextStyles.titleMedium),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: const Icon(Icons.edit_outlined, size: 16, color: AppColors.primary),
                ),
              ]),
              const SizedBox(height: 32),
              Center(
                child: Pinput(
                  controller: _otpController,
                  length: 6,
                  defaultPinTheme: defaultTheme,
                  focusedPinTheme: defaultTheme.copyWith(
                    decoration: BoxDecoration(
                      color: AppColors.ideaPurpleLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary, width: 2),
                    ),
                  ),
                  onCompleted: (_) => _verify(),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: _resendSeconds > 0
                    ? Text(
                        '${AppStrings.resendOtp} 00:${_resendSeconds.toString().padLeft(2, '0')}',
                        style: AppTextStyles.bodyMedium,
                      )
                    : GestureDetector(
                        onTap: () async {
                          await Get.find<AuthController>().sendOtp(phone);
                          _startTimer();
                          setState(() {});
                        },
                        child: Text(AppStrings.resendNow,
                            style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary)),
                      ),
              ),
              const Spacer(),
              PrimaryButton(
                text: 'Verify OTP',
                onPressed: _verify,
                isLoading: _loading,
              ),
              const SizedBox(height: 12),
              Center(
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Text(AppStrings.changeMobile,
                      style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary)),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
