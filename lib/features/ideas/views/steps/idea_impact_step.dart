import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../controllers/idea_controller.dart';

class IdeaImpactStep extends GetView<IdeaController> {
  const IdeaImpactStep({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.ideaImpactHeading, style: AppTextStyles.headlineSmall),
          SizedBox(height: 4.h),
          Text(AppStrings.ideaImpactSubtitle, style: AppTextStyles.bodySmall),
          SizedBox(height: 20.h),
          Text(AppStrings.ideaBenefitsLabel, style: AppTextStyles.titleSmall),
          SizedBox(height: 8.h),
          TextField(controller: controller.benefitsController, maxLines: 4, maxLength: 500,
              decoration: InputDecoration(hintText: AppStrings.ideaBenefitsHint)),
          SizedBox(height: 16.h),
          Text(AppStrings.ideaBeneficiariesLabel, style: AppTextStyles.titleSmall),
          SizedBox(height: 10.h),
          Obx(() => Wrap(
                spacing: 8.w, runSpacing: 8.h,
                children: controller.allBeneficiaries.map((b) {
                  final isSel = controller.beneficiaries.contains(b);
                  return GestureDetector(
                    onTap: () => controller.toggleBeneficiary(b),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: isSel ? AppColors.ideaPurpleLight : AppColors.grey100,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(color: isSel ? AppColors.ideaPurple : AppColors.grey300),
                      ),
                      child: Text(b, style: AppTextStyles.labelSmall.copyWith(color: isSel ? AppColors.ideaPurple : AppColors.textSecondary)),
                    ),
                  );
                }).toList(),
              )),
          SizedBox(height: 16.h),
          Text(AppStrings.ideaResourcesLabel, style: AppTextStyles.titleSmall),
          SizedBox(height: 8.h),
          Obx(() => DropdownButtonFormField<String>(
                value: controller.estimatedResources.value.isEmpty ? null : controller.estimatedResources.value,
                decoration: InputDecoration(hintText: AppStrings.ideaResourcesHint),
                items: controller.resourceRanges.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                onChanged: (v) => controller.estimatedResources.value = v ?? '',
              )),
          SizedBox(height: 32.h),
          PrimaryButton(text: AppStrings.ideaNextVisibility, onPressed: controller.nextStep, backgroundColor: AppColors.ideaPurple),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
