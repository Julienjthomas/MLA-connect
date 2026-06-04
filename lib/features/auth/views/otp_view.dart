import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      width: 52.w,
      height: 58.h,
      textStyle: AppTextStyles.headlineMedium,
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.grey300),
      ),
    );

    return Scaffold(
      appBar: const KeralaAppBar(title: ''),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 32.h),
              Text(AppStrings.verifyOtp, style: AppTextStyles.headlineLarge),
              SizedBox(height: 8.h),
              Text(AppStrings.otpSentTo, style: AppTextStyles.bodyMedium),
              SizedBox(height: 4.h),
              Row(
                children: [
                  Text('+91 ${controller.phone}', style: AppTextStyles.titleMedium),
                  SizedBox(width: 8.w),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(Icons.edit_outlined, size: 16.r, color: AppColors.primary),
                  ),
                ],
              ),
              SizedBox(height: 32.h),
              Center(
                child: Pinput(
                  controller: controller.otpController,
                  length: 6,
                  defaultPinTheme: defaultTheme,
                  focusedPinTheme: defaultTheme.copyWith(
                    decoration: BoxDecoration(
                      color: AppColors.ideaPurpleLight,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: AppColors.primary, width: 2),
                    ),
                  ),
                  onCompleted: (_) => controller.verify(),
                ),
              ),
              SizedBox(height: 16.h),
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
              SizedBox(height: 12.h),
              Center(
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Text(
                    AppStrings.changeMobile,
                    style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}
