import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                Text(AppStrings.enterMobile, style: AppTextStyles.headlineLarge),
                const SizedBox(height: 8),
                Text(AppStrings.mobileSubtitle, style: AppTextStyles.bodyMedium),
                const SizedBox(height: 32),
                TextFormField(
                  controller: controller.phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                  validator: Validators.phone,
                  decoration: InputDecoration(
                    prefixIcon: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.grey100,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.grey300),
                      ),
                      child: const Text('+91', style: AppTextStyles.titleSmall),
                    ),
                    hintText: 'Enter 10 digit mobile number',
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.shield_outlined, size: 14, color: AppColors.textTertiary),
                    const SizedBox(width: 6),
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
                const SizedBox(height: 12),
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
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
