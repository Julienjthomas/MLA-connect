import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_enums.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../controllers/report_controller.dart';

class ReportReviewStep extends GetView<ReportController> {
  const ReportReviewStep({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.reportReviewHeading, style: AppTextStyles.headlineSmall),
          SizedBox(height: 4.h),
          Text(AppStrings.reportReviewSubtitle, style: AppTextStyles.bodySmall),
          SizedBox(height: 20.h),

          _section(AppStrings.reportReviewSectionDetails, [
            _row(
              AppStrings.reportReviewRowCategory,
              controller.selectedCategory.value == ReportCategory.other
                  ? (controller.customCategoryController.text.trim().isEmpty
                        ? controller.selectedCategory.value?.label ?? '–'
                        : controller.customCategoryController.text.trim())
                  : controller.selectedCategory.value?.label ?? '–',
            ),
            _row(AppStrings.reportReviewRowTitle, controller.titleController.text),
            _row(
              AppStrings.reportReviewRowDescription,
              controller.descriptionController.text.isEmpty ? '–' : controller.descriptionController.text,
            ),
          ]),

          SizedBox(height: 16.h),

          Obx(
            () => _section(AppStrings.location, [
              _row(
                AppStrings.reportPanchayatLabel,
                controller.selectedPanchayath.value.isEmpty ? '–' : controller.selectedPanchayath.value,
              ),
              _row(
                AppStrings.reportWardLabel,
                controller.selectedWard.value.isEmpty ? '–' : controller.selectedWard.value,
              ),
              _row(
                AppStrings.landmark,
                controller.locationController.text.trim().isEmpty ? '–' : controller.locationController.text.trim(),
              ),
            ]),
          ),

          SizedBox(height: 16.h),

          Obx(
            () => _section(AppStrings.reportReviewRowVisibility, [
              _row(controller.visibility.value.label, controller.visibility.value.description),
            ]),
          ),

          SizedBox(height: 16.h),

          Obx(() {
            if (controller.selectedImages.isEmpty) return const SizedBox();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                SizedBox(height: 16.h),
              ],
            );
          }),

          Obx(
            () => PrimaryButton(
              text: AppStrings.submitReport,
              onPressed: controller.submit,
              isLoading: controller.isSubmitting.value,
              backgroundColor: AppColors.reportOrange,
              icon: Icon(Icons.send_rounded, color: Colors.white, size: 18.r),
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _section(String title, List<Widget> rows) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.titleSmall.copyWith(color: AppColors.reportOrange)),
          SizedBox(height: 12.h),
          ...rows,
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 100.w, child: Text(label, style: AppTextStyles.caption)),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
