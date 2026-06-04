import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_enums.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../controllers/idea_controller.dart';

class IdeaVisibilityStep extends GetView<IdeaController> {
  const IdeaVisibilityStep({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.ideaVisibilityHeading, style: AppTextStyles.headlineSmall),
          SizedBox(height: 4.h),
          Text(AppStrings.ideaVisibilitySubtitle, style: AppTextStyles.bodySmall),
          SizedBox(height: 24.h),
          Obx(() => Column(
                children: SubmissionVisibility.values.map((v) {
                  final isSelected = controller.visibility.value == v;
                  return GestureDetector(
                    onTap: () => controller.visibility.value = v,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10.h),
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.ideaPurpleLight : AppColors.surface,
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(color: isSelected ? AppColors.ideaPurple : AppColors.grey200, width: isSelected ? 2 : 1),
                      ),
                      child: Row(children: [
                        Container(
                          width: 20.r, height: 20.r,
                          decoration: BoxDecoration(shape: BoxShape.circle,
                              color: isSelected ? AppColors.ideaPurple : Colors.transparent,
                              border: Border.all(color: isSelected ? AppColors.ideaPurple : AppColors.grey400, width: 2)),
                          child: isSelected ? Icon(Icons.check, color: Colors.white, size: 12.r) : null,
                        ),
                        SizedBox(width: 14.w),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(v.label, style: AppTextStyles.titleSmall),
                          Text(v.description, style: AppTextStyles.caption),
                        ])),
                      ]),
                    ),
                  );
                }).toList(),
              )),
          SizedBox(height: 32.h),
          PrimaryButton(text: AppStrings.ideaNextReview, onPressed: controller.nextStep, backgroundColor: AppColors.ideaPurple),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
