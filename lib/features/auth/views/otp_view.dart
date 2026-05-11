import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/kerala_app_bar.dart';
import '../../../core/widgets/primary_button.dart';
import '../controllers/otp_controller.dart';

class OtpView extends GetView<OtpController> {
  const OtpView({super.key});

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
              Row(
                children: [
                  Text('+91 ${controller.phone}', style: AppTextStyles.titleMedium),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: const Icon(Icons.edit_outlined, size: 16, color: AppColors.primary),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Center(
                child: Pinput(
                  controller: controller.otpController,
                  length: 6,
                  defaultPinTheme: defaultTheme,
                  focusedPinTheme: defaultTheme.copyWith(
                    decoration: BoxDecoration(
                      color: AppColors.ideaPurpleLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary, width: 2),
                    ),
                  ),
                  onCompleted: (_) => controller.verify(),
                ),
              ),
              const SizedBox(height: 16),
              Obx(() {
                if (controller.otpExpired.value) {
                  return Center(
                    child: Text(
                      'OTP expired. Resend to get a new code.',
                      style: AppTextStyles.bodyMedium.copyWith(color: const Color(0xFFB00020)),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                final secs = controller.expirySeconds.value;
                final isWarning = secs <= 15;
                return Center(
                  child: Text(
                    'OTP expires in 00:${secs.toString().padLeft(2, '0')}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isWarning ? const Color(0xFFB00020) : AppColors.grey600,
                    ),
                  ),
                );
              }),
              const SizedBox(height: 8),
              Center(
                child: Obx(
                  () => controller.resendSeconds.value > 0
                      ? Text(
                          '${AppStrings.resendOtp} 00:${controller.resendSeconds.value.toString().padLeft(2, '0')}',
                          style: AppTextStyles.bodyMedium,
                        )
                      : GestureDetector(
                          onTap: controller.resend,
                          child: Text(
                            AppStrings.resendNow,
                            style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary),
                          ),
                        ),
                ),
              ),
              const Spacer(),
              Obx(
                () => PrimaryButton(
                  text: 'Verify OTP',
                  onPressed: controller.otpExpired.value ? null : controller.verify,
                  isLoading: controller.loading.value,
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Text(
                    AppStrings.changeMobile,
                    style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary),
                  ),
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
