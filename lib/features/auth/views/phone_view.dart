import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/kerala_app_bar.dart';
import '../../../core/widgets/primary_button.dart';
import '../controllers/phone_controller.dart';

class PhoneView extends GetView<PhoneController> {
  const PhoneView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const KeralaAppBar(title: ''),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 32.h),
                Text(AppStrings.enterMobile, style: AppTextStyles.headlineLarge),
                SizedBox(height: 8.h),
                Text(AppStrings.mobileSubtitle, style: AppTextStyles.bodyMedium),
                SizedBox(height: 32.h),
                TextFormField(
                  controller: controller.phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                  validator: Validators.phone,
                  decoration: InputDecoration(
                    prefixIcon: Container(
                      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: AppColors.grey100,
                        borderRadius: BorderRadius.circular(6.r),
                        border: Border.all(color: AppColors.grey300),
                      ),
                      child: const Text('+91', style: AppTextStyles.titleSmall),
                    ),
                    hintText: 'Enter 10 digit mobile number',
                  ),
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Icon(Icons.shield_outlined, size: 14.r, color: AppColors.textTertiary),
                    SizedBox(width: 6.w),
                    Text(AppStrings.privacyNote, style: AppTextStyles.caption),
                  ],
                ),
                const Spacer(),
                Obx(
                  () => PrimaryButton(
                    text: AppStrings.sendOtp,
                    onPressed: controller.sendOtp,
                    isLoading: controller.loading.value,
                  ),
                ),
                SizedBox(height: 12.h),
                Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: AppTextStyles.caption,
                      children: [
                        const TextSpan(text: 'By continuing, you agree to our '),
                        TextSpan(
                          text: 'Terms & Privacy Policy',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.primary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
