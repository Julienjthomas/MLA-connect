import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_strings.dart';
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
              decoration: const BoxDecoration(color: AppColors.reportOrange, shape: BoxShape.circle),
              child: const Icon(Icons.check_rounded, color: Colors.white, size: 60),
            ),
            const SizedBox(height: 24),
            Text(
              AppStrings.reportSuccess,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                height: 1.3,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(AppStrings.reportSuccessMsg, style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
            const Spacer(),
            PrimaryButton(
              backgroundColor: AppColors.reportOrange,
              text: AppStrings.trackInActivity,
              onPressed: () {
                Get.until((r) => r.settings.name == '/home');
              },
            ),
            const SizedBox(height: 12),
            SecondaryButton(
              text: AppStrings.reportAnother,
              onPressed: () {
                Get.back();
                Get.toNamed('/report/flow');
              },
              color: AppColors.reportOrange,
            ),
          ],
        ),
      ),
    );
  }
}
