import 'package:flutter/material.dart';
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

  /// Row height for each tile; sized for icon chip + 2-line text at up to ~1.3 text scale.
  static const double _tileRowHeight = 84;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
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
            const SizedBox(height: 12),
            GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                mainAxisExtent: _tileRowHeight,
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
