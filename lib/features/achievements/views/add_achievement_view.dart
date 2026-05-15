import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/kerala_app_bar.dart';
import '../../../core/widgets/primary_button.dart';
import '../controllers/achievements_controller.dart';

class AddAchievementView extends GetView<AchievementsController> {
  const AddAchievementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const KeralaAppBar(title: 'Add Achievement'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Achievement Details', style: AppTextStyles.headlineSmall),
            const SizedBox(height: 4),
            const Text('Share a recognition for the Hall of Excellence', style: AppTextStyles.bodySmall),
            const SizedBox(height: 20),
            const Text('Achiever Name *', style: AppTextStyles.titleSmall),
            const SizedBox(height: 8),
            TextField(
              controller: controller.nameController,
              decoration: const InputDecoration(hintText: 'Full name'),
            ),
            const SizedBox(height: 14),
            const Text('Institution *', style: AppTextStyles.titleSmall),
            const SizedBox(height: 8),
            TextField(
              controller: controller.institutionController,
              decoration: const InputDecoration(hintText: 'School or organization'),
            ),
            const SizedBox(height: 14),
            const Text('Achievement *', style: AppTextStyles.titleSmall),
            const SizedBox(height: 8),
            TextField(
              controller: controller.achievementController,
              decoration: const InputDecoration(hintText: 'e.g. SSLC Full A+'),
            ),
            const SizedBox(height: 28),
            PrimaryButton(
              text: 'Submit Achievement',
              onPressed: controller.submitAchievement,
              backgroundColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
