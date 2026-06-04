import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class MaintenanceScreen extends StatelessWidget {
  const MaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 48.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100.r,
                height: 100.r,
                decoration: const BoxDecoration(
                  color: AppColors.statusUnderReviewBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.build_rounded, size: 52.r, color: AppColors.statusUnderReview),
              ),
              SizedBox(height: 32.h),
              const Text(
                'Under Maintenance',
                style: AppTextStyles.headlineMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              Text(
                'MLA Connect is currently undergoing scheduled maintenance. We\'ll be back shortly.',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 16.r,
                    height: 16.r,
                    child: const CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'Checking status…',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
