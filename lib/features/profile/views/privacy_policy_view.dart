import 'package:flutter/material.dart';
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
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(AppStrings.privacyPolicy, style: AppTextStyles.titleMedium),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ...sections.expand((s) => [
                Text(s.title, style: AppTextStyles.titleSmall),
                const SizedBox(height: 4),
                Text(s.body,
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: 16),
              ]),
          const SizedBox(height: 8),
          Text(AppStrings.privacyLastUpdated,
              style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary)),
        ],
      ),
    );
  }
}
