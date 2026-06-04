import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        padding: EdgeInsets.all(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Achievement Details', style: AppTextStyles.headlineSmall),
            SizedBox(height: 4.h),
            const Text('Share a recognition for the Hall of Excellence', style: AppTextStyles.bodySmall),
            SizedBox(height: 20.h),
            const Text('Achiever Name *', style: AppTextStyles.titleSmall),
            SizedBox(height: 8.h),
            TextField(
              controller: controller.nameController,
              decoration: const InputDecoration(hintText: 'Full name'),
            ),
            SizedBox(height: 14.h),
            const Text('Institution *', style: AppTextStyles.titleSmall),
            SizedBox(height: 8.h),
            TextField(
              controller: controller.institutionController,
              decoration: const InputDecoration(hintText: 'School or organization'),
            ),
            SizedBox(height: 14.h),
            const Text('Achievement *', style: AppTextStyles.titleSmall),
            SizedBox(height: 8.h),
            TextField(
              controller: controller.achievementController,
              decoration: const InputDecoration(hintText: 'e.g. SSLC Full A+'),
            ),
            SizedBox(height: 28.h),
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
