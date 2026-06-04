import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_enums.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../routes/app_routes.dart';
import 'quick_action_tile.dart';

/// Home-screen Quick actions card (2×2 horizontal tiles).
class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.grey200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.quickActions,
              style: AppTextStyles.titleMedium.copyWith(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 12.h),
            GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 12.h,
                mainAxisExtent: 96.h,
              ),
              children: [
                    QuickActionTile(
                      icon: FeatureType.report.icon,
                      title: AppStrings.quickActionIssue,
                      subtitle: AppStrings.quickActionIssueSubtitle,
                      accentColor: FeatureType.report.color,
                      onTap: () => Get.toNamed(Routes.reportFlow),
                    ),
                    QuickActionTile(
                      icon: FeatureType.idea.icon,
                      title: AppStrings.quickActionIdea,
                      subtitle: AppStrings.quickActionIdeaSubtitle,
                      accentColor: FeatureType.idea.color,
                      onTap: () => Get.toNamed(Routes.ideasFlow),
                    ),
                    QuickActionTile(
                      icon: FeatureType.improve.icon,
                      title: AppStrings.quickActionSuggest,
                      subtitle: AppStrings.quickActionSuggestSubtitle,
                      accentColor: FeatureType.improve.color,
                      onTap: () => Get.toNamed(Routes.improvementsFlow),
                    ),
                    QuickActionTile(
                      icon: FeatureType.appreciate.icon,
                      title: AppStrings.quickActionAppreciate,
                      subtitle: AppStrings.quickActionAppreciateSubtitle,
                      accentColor: FeatureType.appreciate.color,
                      onTap: () => Get.toNamed(Routes.appreciationFlow),
                    ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
