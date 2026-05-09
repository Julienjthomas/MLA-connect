import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_enums.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../controllers/idea_controller.dart';

class IdeaReviewStep extends GetView<IdeaController> {
  const IdeaReviewStep({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Please review your idea before submitting', style: AppTextStyles.headlineSmall),
          const SizedBox(height: 20),
          _card('Idea Details', [
            _row('Topic', controller.topic.value),
            _row('Title', controller.titleController.text),
            _row('Description', controller.descriptionController.text.isEmpty ? '–' : controller.descriptionController.text),
          ]),
          const SizedBox(height: 12),
          _card('Impact & Benefits', [
            _row('Benefits', controller.benefitsController.text.isEmpty ? '–' : controller.benefitsController.text),
            _row('Beneficiaries', controller.beneficiaries.isEmpty ? '–' : controller.beneficiaries.join(', ')),
            _row('Resources', controller.estimatedResources.value.isEmpty ? '–' : controller.estimatedResources.value),
          ]),
          const SizedBox(height: 12),
          _card('Visibility', [
            _row('Visibility', controller.visibility.value.label),
            _row('Community Discussion', controller.allowDiscussion.value ? 'Enabled' : 'Disabled'),
            _row('MLA Contact', controller.allowContact.value ? 'Yes' : 'No'),
          ]),
          const SizedBox(height: 32),
          Obx(() => PrimaryButton(
                text: 'Submit Idea 🚀',
                onPressed: controller.submit,
                isLoading: controller.isSubmitting.value,
                backgroundColor: AppColors.ideaPurple,
              )),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _card(String title, List<Widget> rows) => Container(
        margin: const EdgeInsets.only(bottom: 0),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.grey200)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: AppTextStyles.titleSmall.copyWith(color: AppColors.ideaPurple)),
          const SizedBox(height: 10), ...rows,
        ]),
      );

  Widget _row(String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(width: 100, child: Text(label, style: AppTextStyles.caption)),
          Expanded(child: Text(value, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w500))),
        ]),
      );
}
