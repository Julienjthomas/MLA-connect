import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../controllers/report_controller.dart';

class ReportSuccessStep extends GetView<ReportController> {
  const ReportSuccessStep({super.key});

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
              child: const Icon(Icons.check_rounded, color: Colors.white, size: 60),
            ),
            const SizedBox(height: 24),
            const Text(
              'Your Report has been\nSubmitted Successfully!',
              style: TextStyle(fontFamily: 'Poppins', fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary, height: 1.3),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'We received your report and our team will take action soon.',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Obx(() {
              final id = controller.submittedId.value;
              final refText = id.isEmpty
                  ? 'RP2024001256'
                  : 'RP${(id.length <= 8 ? id : id.substring(0, 8)).toUpperCase()}';
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(children: [
                  Text('Your Reference ID', style: AppTextStyles.caption),
                  const SizedBox(height: 4),
                  Text(
                    refText,
                    style: AppTextStyles.titleLarge.copyWith(color: AppColors.primary),
                  ),
                ]),
              );
            }),
            const Spacer(),
            PrimaryButton(
              text: 'Track in My Activity',
              onPressed: () {
                Get.until((r) => r.settings.name == '/home');
                // Switch to activity tab
              },
            ),
            const SizedBox(height: 12),
            SecondaryButton(
              text: 'Report Another Issue',
              onPressed: () {
                Get.back();
                Get.toNamed('/report/flow');
              },
              color: AppColors.reportOrange,
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Get.until((r) => r.settings.name == '/home'),
              child: Text('Go to Home', style: AppTextStyles.labelMedium.copyWith(color: AppColors.textTertiary)),
            ),
          ],
        ),
      ),
    );
  }
}
