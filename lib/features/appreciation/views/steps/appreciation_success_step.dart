import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
              width: 100, height: 100,
              decoration: const BoxDecoration(color: AppColors.appreciateGreen, shape: BoxShape.circle),
              child: const Icon(Icons.favorite_rounded, color: Colors.white, size: 56),
            ),
            const SizedBox(height: 24),
            const Text('Thank You!\nYour appreciation has been\nshared successfully.',
                style: TextStyle(fontFamily: 'Poppins', fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary, height: 1.3),
                textAlign: TextAlign.center),
            const SizedBox(height: 12),
            Text('Your kind words will motivate them to do even better.',
                style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
            const Spacer(),
            PrimaryButton(
              text: 'Go to My Activity',
              onPressed: () => Get.until((r) => r.settings.name == '/home'),
              backgroundColor: AppColors.appreciateGreen,
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                Get.back();
                Get.toNamed('/appreciation/flow');
              },
              child: Text('Send Another Appreciation', style: AppTextStyles.labelMedium.copyWith(color: AppColors.appreciateGreen)),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
