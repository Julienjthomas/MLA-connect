import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
          Text('Review your suggestion', style: AppTextStyles.headlineSmall),
          const SizedBox(height: 4),
          Text('Please review before submitting', style: AppTextStyles.bodySmall),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.grey200)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Suggestion Details', style: AppTextStyles.titleSmall.copyWith(color: AppColors.improveBlue)),
              const SizedBox(height: 10),
              _row('Department', controller.department.value.isEmpty ? '–' : controller.department.value),
              _row('Suggestion', controller.suggestionController.text),
              _row('Location', controller.locationController.text.isEmpty ? '–' : controller.locationController.text),
              _row('Landmark', controller.landmarkController.text.isEmpty ? '–' : controller.landmarkController.text),
            ]),
          ),
          const SizedBox(height: 32),
          Obx(() => PrimaryButton(
                text: 'Submit Suggestion',
                onPressed: controller.submit,
                isLoading: controller.isSubmitting.value,
                backgroundColor: AppColors.improveBlue,
              )),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _row(String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(width: 100, child: Text(label, style: AppTextStyles.caption)),
          Expanded(child: Text(value, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w500))),
        ]),
      );
}
