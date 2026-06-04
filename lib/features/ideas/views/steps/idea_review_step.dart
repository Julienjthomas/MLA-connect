import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.ideaReviewHeading, style: AppTextStyles.headlineSmall),
          SizedBox(height: 20.h),
          _card(AppStrings.ideaCardDetails, [
            _row(AppStrings.ideaRowTopic, controller.topic.value),
            _row(AppStrings.reportReviewRowTitle, controller.titleController.text),
            _row(AppStrings.reportReviewRowDescription, controller.descriptionController.text.isEmpty ? '–' : controller.descriptionController.text),
          ]),
          SizedBox(height: 12.h),
          _card(AppStrings.ideaCardImpact, [
            _row(AppStrings.ideaRowBenefits, controller.benefitsController.text.isEmpty ? '–' : controller.benefitsController.text),
            _row(AppStrings.ideaRowBeneficiaries, controller.beneficiaries.isEmpty ? '–' : controller.beneficiaries.join(', ')),
            _row(AppStrings.ideaRowResources, controller.estimatedResources.value.isEmpty ? '–' : controller.estimatedResources.value),
          ]),
          SizedBox(height: 12.h),
          _card(AppStrings.ideaCardVisibility, [
            _row(AppStrings.reportReviewRowVisibility, controller.visibility.value.label),
          ]),
          Obx(() {
            if (controller.selectedImages.isEmpty) return const SizedBox();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
                Text('${AppStrings.photos} (${controller.selectedImages.length})', style: AppTextStyles.titleSmall),
                SizedBox(height: 8.h),
                SizedBox(
                  height: 70.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.selectedImages.length,
                    itemBuilder: (_, i) => Container(
                      width: 70.r,
                      height: 70.r,
                      margin: EdgeInsets.only(right: 8.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
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
          SizedBox(height: 32.h),
          Obx(() => PrimaryButton(
                text: AppStrings.ideaSubmitBtn,
                onPressed: controller.submit,
                isLoading: controller.isSubmitting.value,
                backgroundColor: AppColors.ideaPurple,
              )),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _card(String title, List<Widget> rows) => Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14.r), border: Border.all(color: AppColors.grey200)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: AppTextStyles.titleSmall.copyWith(color: AppColors.ideaPurple)),
          SizedBox(height: 10.h), ...rows,
        ]),
      );

  Widget _row(String label, String value) => Padding(
        padding: EdgeInsets.only(bottom: 6.h),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(width: 100.w, child: Text(label, style: AppTextStyles.caption)),
          Expanded(child: Text(value, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w500))),
        ]),
      );
}
