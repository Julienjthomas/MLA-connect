import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_enums.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../controllers/appreciation_controller.dart';

class AppreciationReviewStep extends GetView<AppreciationController> {
  const AppreciationReviewStep({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.appreciateReviewHeading, style: AppTextStyles.headlineSmall),
          const SizedBox(height: 4),
          Text(AppStrings.appreciateReviewSubtitle, style: AppTextStyles.bodySmall),
          const SizedBox(height: 20),
          _card(AppStrings.appreciateCardRecipient, [
            _row(AppStrings.recipientCategory, controller.recipientCategory.value),
            _row(AppStrings.appreciateRowStaff, controller.staffController.text.isEmpty ? '–' : controller.staffController.text),
            _row(AppStrings.appreciateRowRelatedWork, controller.relatedWorkController.text.isEmpty ? '–' : controller.relatedWorkController.text),
          ]),
          const SizedBox(height: 12),
          _card(AppStrings.appreciateCardMessage, [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(controller.messageController.text, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary)),
            ),
          ]),
          const SizedBox(height: 12),
          _card(AppStrings.appreciateCardVisibility, [
            _row(AppStrings.reportReviewRowVisibility, controller.visibility.value.label),
            _row(AppStrings.appreciateRowAnonymous, controller.anonymous.value ? AppStrings.yesLabel : AppStrings.noLabel),
          ]),
          const SizedBox(height: 32),
          Obx(() => PrimaryButton(
                text: AppStrings.appreciateSubmitBtn,
                onPressed: controller.submit,
                isLoading: controller.isSubmitting.value,
                backgroundColor: AppColors.appreciateGreen,
                icon: const Icon(Icons.favorite_rounded, color: Colors.white, size: 18),
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
          Text(title, style: AppTextStyles.titleSmall.copyWith(color: AppColors.appreciateGreen)),
          const SizedBox(height: 10),
          ...rows,
        ]),
      );

  Widget _row(String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(width: 90, child: Text(label, style: AppTextStyles.caption)),
          Expanded(child: Text(value, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w500))),
        ]),
      );
}
