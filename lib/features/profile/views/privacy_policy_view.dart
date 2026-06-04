import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    final sections = AppStrings.privacySections;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(AppStrings.privacyPolicy, style: AppTextStyles.titleMedium),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.r),
        children: [
          ...sections.expand((s) => [
                Text(s.title, style: AppTextStyles.titleSmall),
                SizedBox(height: 4.h),
                Text(s.body,
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                SizedBox(height: 16.h),
              ]),
          SizedBox(height: 8.h),
          Text(AppStrings.privacyLastUpdated,
              style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary)),
        ],
      ),
    );
  }
}
