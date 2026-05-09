import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/kerala_app_bar.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../routes/app_routes.dart';
import '../controllers/onboarding_controller.dart';

class LanguageView extends GetView<OnboardingController> {
  const LanguageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const KeralaAppBar(title: ''),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              const Text(AppStrings.selectLanguage, style: AppTextStyles.headlineLarge),
              const SizedBox(height: 8),
              const Text(AppStrings.chooseLanguage, style: AppTextStyles.bodyMedium),
              const SizedBox(height: 32),
              Obx(
                () => Column(
                  children: [
                    _languageTile('en', 'English', 'English'),
                    const SizedBox(height: 12),
                    _languageTile('ml', 'മലയാളം', 'Malayalam'),
                  ],
                ),
              ),
              const Spacer(),
              PrimaryButton(text: AppStrings.continueBtn, onPressed: () => Get.toNamed(Routes.phone)),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _languageTile(String code, String nativeName, String englishName) {
    final isSelected = controller.selectedLanguage.value == code;
    return GestureDetector(
      onTap: () => controller.selectedLanguage.value = code,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.08) : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.grey300, width: isSelected ? 2 : 1),
        ),
        child: Row(
          children: [
            Text(
              nativeName,
              style: AppTextStyles.titleMedium.copyWith(color: isSelected ? AppColors.primary : AppColors.textPrimary),
            ),
            const SizedBox(width: 8),
            Text('· $englishName', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
            const Spacer(),
            if (isSelected) const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 22),
          ],
        ),
      ),
    );
  }
}
