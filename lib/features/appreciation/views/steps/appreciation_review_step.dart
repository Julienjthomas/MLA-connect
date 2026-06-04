import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../controllers/appreciation_controller.dart';

const _categoryLabels = {
  'public_works': 'Public Works',
  'quick_response': 'Quick Response',
  'helpful_support': 'Helpful Support',
  'community_initiative': 'Community Initiative',
  'good_leadership': 'Good Leadership',
  'other': 'Other',
};

class AppreciationReviewStep extends GetView<AppreciationController> {
  const AppreciationReviewStep({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.appreciateReviewHeading, style: AppTextStyles.headlineSmall),
          SizedBox(height: 4.h),
          Text(AppStrings.appreciateReviewSubtitle, style: AppTextStyles.bodySmall),
          SizedBox(height: 20.h),
          Obx(() {
            final category = controller.recipientCategory.value;
            final message = controller.messageController.text.trim();
            return Column(
              children: [
                _card('Appreciation Details', [
                  _row('Category', _categoryLabels[category] ?? category),
                  if (message.isNotEmpty)
                    _row('Message', message),
                ]),
              ],
            );
          }),
          SizedBox(height: 32.h),
          Obx(() => PrimaryButton(
                text: AppStrings.appreciateSubmitBtn,
                onPressed: controller.submit,
                isLoading: controller.isSubmitting.value,
                backgroundColor: AppColors.appreciateGreen,
                icon: Icon(Icons.favorite_rounded, color: Colors.white, size: 18.r),
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
          Text(title, style: AppTextStyles.titleSmall.copyWith(color: AppColors.appreciateGreen)),
          SizedBox(height: 10.h),
          ...rows,
        ]),
      );

  Widget _row(String label, String value) => Padding(
        padding: EdgeInsets.only(bottom: 6.h),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(width: 90.w, child: Text(label, style: AppTextStyles.caption)),
          Expanded(child: Text(value, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w500))),
        ]),
      );
}
