import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_enums.dart';
import '../../../../core/constants/app_strings.dart';
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
          Text(AppStrings.ideaReviewHeading, style: AppTextStyles.headlineSmall),
          const SizedBox(height: 20),
          _card(AppStrings.ideaCardDetails, [
            _row(AppStrings.ideaRowTopic, controller.topic.value),
            _row(AppStrings.reportReviewRowTitle, controller.titleController.text),
            _row(AppStrings.reportReviewRowDescription, controller.descriptionController.text.isEmpty ? '–' : controller.descriptionController.text),
          ]),
          const SizedBox(height: 12),
          _card(AppStrings.ideaCardImpact, [
            _row(AppStrings.ideaRowBenefits, controller.benefitsController.text.isEmpty ? '–' : controller.benefitsController.text),
            _row(AppStrings.ideaRowBeneficiaries, controller.beneficiaries.isEmpty ? '–' : controller.beneficiaries.join(', ')),
            _row(AppStrings.ideaRowResources, controller.estimatedResources.value.isEmpty ? '–' : controller.estimatedResources.value),
          ]),
          const SizedBox(height: 12),
          _card(AppStrings.ideaCardVisibility, [
            _row(AppStrings.reportReviewRowVisibility, controller.visibility.value.label),
          ]),
          Obx(() {
            if (controller.selectedImages.isEmpty) return const SizedBox();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text('${AppStrings.photos} (${controller.selectedImages.length})', style: AppTextStyles.titleSmall),
                const SizedBox(height: 8),
                SizedBox(
                  height: 70,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.selectedImages.length,
                    itemBuilder: (_, i) => Container(
                      width: 70,
                      height: 70,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: FileImage(File(controller.selectedImages[i].path)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
          const SizedBox(height: 32),
          Obx(() => PrimaryButton(
                text: AppStrings.ideaSubmitBtn,
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
