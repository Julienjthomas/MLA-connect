import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';

class ImprovementSuccessStep extends StatelessWidget {
  const ImprovementSuccessStep({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Container(
              width: 100.r,
              height: 100.r,
              decoration: const BoxDecoration(color: AppColors.improveBlue, shape: BoxShape.circle),
              child: Icon(Icons.check_rounded, color: Colors.white, size: 60.r),
            ),
            SizedBox(height: 24.h),
            Text(
              AppStrings.improvementSuccess,
              style: TextStyle(fontFamily: 'Poppins', fontSize: 22.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary, height: 1.3),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            Text(AppStrings.improveSuccessMsg, style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
            const Spacer(),
            PrimaryButton(
              text: AppStrings.improveGoHome,
              onPressed: () => Get.until((r) => r.settings.name == '/home'),
              backgroundColor: AppColors.improveBlue,
            ),
            SizedBox(height: 12.h),
            SecondaryButton(
              text: AppStrings.improveSubmitAnother,
              onPressed: () {
                Get.back();
                Get.toNamed('/improvements/flow');
              },
              color: AppColors.improveBlue,
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }
}
