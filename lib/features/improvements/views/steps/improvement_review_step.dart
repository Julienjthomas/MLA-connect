import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../controllers/improvement_controller.dart';

class ImprovementReviewStep extends GetView<ImprovementController> {
  const ImprovementReviewStep({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.improveReviewHeading, style: AppTextStyles.headlineSmall),
          const SizedBox(height: 4),
          Text(AppStrings.improveReviewSubtitle, style: AppTextStyles.bodySmall),
          const SizedBox(height: 20),
          _section(AppStrings.improveCardDetails, [
            _row(AppStrings.improveRowDept, controller.department.value.isEmpty ? '–' : controller.department.value),
            _row(AppStrings.improveRowSuggestion, controller.suggestionController.text.isEmpty ? '–' : controller.suggestionController.text),
          ]),
          const SizedBox(height: 16),
          Obx(() => _section(AppStrings.location, [
            _row(AppStrings.reportPanchayatLabel, controller.selectedPanchayath.value.isEmpty ? '–' : controller.selectedPanchayath.value),
            _row(AppStrings.reportWardLabel, controller.selectedWard.value.isEmpty ? '–' : controller.selectedWard.value),
            _row(AppStrings.landmark, controller.landmarkController.text.isEmpty ? '–' : controller.landmarkController.text),
          ])),
          const SizedBox(height: 32),
          Obx(() => PrimaryButton(
                text: AppStrings.improveSubmitBtn,
                onPressed: controller.submit,
                isLoading: controller.isSubmitting.value,
                backgroundColor: AppColors.improveBlue,
                icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
              )),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _section(String title, List<Widget> rows) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.grey200),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: AppTextStyles.titleSmall.copyWith(color: AppColors.improveBlue)),
          const SizedBox(height: 10),
          ...rows,
        ]),
      );

  Widget _row(String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(width: 100, child: Text(label, style: AppTextStyles.caption)),
          Expanded(child: Text(value, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w500))),
        ]),
      );
}
