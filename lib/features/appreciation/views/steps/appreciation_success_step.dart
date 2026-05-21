import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';

class AppreciationSuccessStep extends StatelessWidget {
  const AppreciationSuccessStep({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(color: AppColors.appreciateGreen, shape: BoxShape.circle),
              child: const Icon(Icons.check_rounded, color: Colors.white, size: 56),
            ),
            const SizedBox(height: 24),
            Text(
              AppStrings.appreciationSuccess,
              style: const TextStyle(fontFamily: 'Poppins', fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary, height: 1.3),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(AppStrings.appreciateSuccessMotivation, style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
            const Spacer(),
            PrimaryButton(
              text: AppStrings.goToMyActivity,
              onPressed: () => Get.until((r) => r.settings.name == '/home'),
              backgroundColor: AppColors.appreciateGreen,
            ),
            const SizedBox(height: 12),
            SecondaryButton(
              text: AppStrings.appreciateSendAnother,
              onPressed: () {
                Get.back();
                Get.toNamed('/appreciation/flow');
              },
              color: AppColors.appreciateGreen,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
