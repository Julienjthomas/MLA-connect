import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_enums.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../controllers/report_controller.dart';

class ReportVisibilityStep extends GetView<ReportController> {
  const ReportVisibilityStep({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.location, style: AppTextStyles.headlineSmall),
          const SizedBox(height: 4),
          Text(AppStrings.reportVisibilitySubtitle, style: AppTextStyles.bodySmall),
          const SizedBox(height: 24),
          Text(AppStrings.reportVisibilityFieldLabel, style: AppTextStyles.titleSmall),
          const SizedBox(height: 10),
          Obx(
            () => Column(
              children: SubmissionVisibility.values.map((v) {
                final isSelected = controller.visibility.value == v;
                return GestureDetector(
                  onTap: () => controller.visibility.value = v,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.reportOrange.withValues(alpha: 0.08) : AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? AppColors.reportOrange : AppColors.grey200,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected ? AppColors.reportOrange : Colors.transparent,
                            border: Border.all(
                              color: isSelected ? AppColors.reportOrange : AppColors.grey400,
                              width: 2,
                            ),
                          ),
                          child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 12) : null,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(v.label, style: AppTextStyles.titleSmall),
                              Text(v.description, style: AppTextStyles.caption),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 32),
          PrimaryButton(
            text: AppStrings.reportNextReview,
            onPressed: controller.nextStep,
            backgroundColor: AppColors.reportOrange,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
