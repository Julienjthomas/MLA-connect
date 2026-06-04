import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../features/auth/controllers/auth_controller.dart';
import '../../../routes/app_routes.dart';

class OnboardingSuccessView extends StatelessWidget {
  const OnboardingSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                width: 96.r,
                height: 96.r,
                decoration: const BoxDecoration(color: AppColors.appreciateGreen, shape: BoxShape.circle),
                child: Icon(Icons.check_rounded, color: Colors.white, size: 56.r),
              ),
              SizedBox(height: 24.h),
              Text(AppStrings.allSet, style: AppTextStyles.headlineLarge, textAlign: TextAlign.center),
              SizedBox(height: 8.h),
              Text(AppStrings.allSetSubtitle, style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
              SizedBox(height: 32.h),
              Obx(() {
                final user = auth.user.value;
                return Container(
                  padding: EdgeInsets.all(20.r),
                  decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(16.r)),
                  child: Column(
                    children: [
                      _infoRow(Icons.location_on_outlined, 'Local Body', user?.localBodyName ?? '–'),
                      SizedBox(height: 12.h),
                      _infoRow(Icons.map_outlined, 'Ward', user?.wardName ?? '–'),
                    ],
                  ),
                );
              }),
              const Spacer(),
              PrimaryButton(
                text: AppStrings.goToHome,
                onPressed: () => Get.offAllNamed(Routes.home),
                backgroundColor: AppColors.appreciateGreen,
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18.r, color: AppColors.textTertiary),
        SizedBox(width: 10.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.caption),
            Text(value, style: AppTextStyles.titleSmall),
          ],
        ),
      ],
    );
  }
}
