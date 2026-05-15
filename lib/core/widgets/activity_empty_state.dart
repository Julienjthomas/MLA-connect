import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../constants/app_assets.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../../routes/app_routes.dart';
import 'action_card.dart';
import 'primary_button.dart';

class ActivityEmptyState extends StatelessWidget {
  const ActivityEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 88),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(AppAssets.emptyLottie, width: 180, height: 180),
          const SizedBox(height: 16),
          const Text(
            'Start contributing to your community',
            style: AppTextStyles.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Report issues, share ideas and track updates from your constituency.',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textTertiary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            text: 'Report a Problem',
            onPressed: () => Get.toNamed(Routes.reportFlow),
          ),
          const SizedBox(height: 16),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ActionCard(
                    icon: Icons.lightbulb_outline,
                    title: 'Share Idea',
                    subtitle: 'Suggest ideas to improve your area',
                    accentColor: AppColors.ideaPurple,
                    onTap: () => Get.toNamed(Routes.ideasFlow),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ActionCard(
                    icon: Icons.tips_and_updates_outlined,
                    title: 'Suggest',
                    subtitle: 'Improvements for your constituency',
                    accentColor: AppColors.improveBlue,
                    onTap: () => Get.toNamed(Routes.improvementsFlow),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ActionCard(
                    icon: Icons.favorite_outline,
                    title: 'Appreciate',
                    subtitle: 'Recognize good work',
                    accentColor: AppColors.appreciateGreen,
                    onTap: () => Get.toNamed(Routes.appreciationFlow),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
