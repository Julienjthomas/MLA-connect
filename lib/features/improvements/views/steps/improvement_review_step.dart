import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.improveReviewHeading, style: AppTextStyles.headlineSmall),
          SizedBox(height: 4.h),
          Text(AppStrings.improveReviewSubtitle, style: AppTextStyles.bodySmall),
          SizedBox(height: 20.h),
          _section(AppStrings.improveCardDetails, [
            _row(AppStrings.improveRowDept, controller.department.value.isEmpty ? '–' : controller.department.value),
            _row(AppStrings.improveRowSuggestion, controller.suggestionController.text.isEmpty ? '–' : controller.suggestionController.text),
          ]),
          SizedBox(height: 16.h),
          Obx(() => _section(AppStrings.location, [
            _row(AppStrings.reportPanchayatLabel, controller.selectedPanchayath.value.isEmpty ? '–' : controller.selectedPanchayath.value),
            _row(AppStrings.reportWardLabel, controller.selectedWard.value.isEmpty ? '–' : controller.selectedWard.value),
            _row(AppStrings.landmark, controller.landmarkController.text.isEmpty ? '–' : controller.landmarkController.text),
          ])),
          SizedBox(height: 32.h),
          Obx(() => PrimaryButton(
                text: AppStrings.improveSubmitBtn,
                onPressed: controller.submit,
                isLoading: controller.isSubmitting.value,
                backgroundColor: AppColors.improveBlue,
                icon: Icon(Icons.send_rounded, color: Colors.white, size: 18.r),
              )),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _section(String title, List<Widget> rows) => Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: AppColors.grey200),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: AppTextStyles.titleSmall.copyWith(color: AppColors.improveBlue)),
          SizedBox(height: 10.h),
          ...rows,
        ]),
      );

  Widget _row(String label, String value) => Padding(
        padding: EdgeInsets.only(bottom: 8.h),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(width: 100.w, child: Text(label, style: AppTextStyles.caption)),
          Expanded(child: Text(value, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w500))),
        ]),
      );
}
