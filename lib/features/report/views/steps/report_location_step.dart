import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../features/auth/controllers/auth_controller.dart';
import '../../controllers/report_controller.dart';

class ReportLocationStep extends GetView<ReportController> {
  const ReportLocationStep({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.location, style: AppTextStyles.headlineSmall),
          SizedBox(height: 4.h),
          Text(AppStrings.reportLocationSubtitle, style: AppTextStyles.bodySmall),
          SizedBox(height: 20.h),

          Text(AppStrings.reportPanchayatLabel, style: AppTextStyles.titleSmall),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.grey200),
            ),
            child: Row(children: [
              Icon(Icons.location_city_outlined, size: 18.r, color: AppColors.grey500),
              SizedBox(width: 10.w),
              Text(
                Get.find<AuthController>().user.value?.localBodyName ?? AppStrings.reportPanchayatLabel,
                style: AppTextStyles.bodyMedium,
              ),
            ]),
          ),

          SizedBox(height: 14.h),

          Text(AppStrings.reportWardLabel, style: AppTextStyles.titleSmall),
          SizedBox(height: 8.h),
          TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.map_outlined, size: 20.r),
            ),
          ),

          SizedBox(height: 14.h),

          Text(AppStrings.reportLandmarkAreaLabel, style: AppTextStyles.titleSmall),
          SizedBox(height: 8.h),
          TextField(
            controller: controller.landmarkController,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.place_outlined, size: 20.r),
            ),
          ),

          SizedBox(height: 14.h),

          Text(AppStrings.reportLocationDescLabel, style: AppTextStyles.titleSmall),
          SizedBox(height: 8.h),
          TextField(
            controller: controller.locationController,
            decoration: InputDecoration(
              hintText: AppStrings.reportLocationDescHint,
            ),
          ),

          SizedBox(height: 6.h),
          Row(children: [
            Icon(Icons.info_outline, size: 13.r, color: AppColors.textTertiary),
            SizedBox(width: 4.w),
            Text(AppStrings.reportGpsNote, style: AppTextStyles.caption),
          ]),

          SizedBox(height: 14.h),

          Container(
            height: 140.h,
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: AppColors.grey200),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.map_outlined, size: 40.r, color: AppColors.grey400),
                  SizedBox(height: 8.h),
                  Text(AppStrings.reportMapPin, style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey500)),
                ],
              ),
            ),
          ),

          SizedBox(height: 14.h),

          Text(AppStrings.reportContactLabel, style: AppTextStyles.titleSmall),
          SizedBox(height: 8.h),
          TextField(
            controller: controller.contactController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.phone_outlined, size: 20.r),
            ),
          ),

          SizedBox(height: 32.h),

          PrimaryButton(
            text: AppStrings.reportNextReview,
            onPressed: controller.nextStep,
            backgroundColor: AppColors.reportOrange,
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
