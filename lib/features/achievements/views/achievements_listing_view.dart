import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/shimmer_loader.dart';
import '../../../routes/app_routes.dart';
import '../controllers/achievements_controller.dart';

class AchievementsListingView extends GetView<AchievementsController> {
  const AchievementsListingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('Hall of Excellence', style: AppTextStyles.titleLarge),
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.loading.value) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: 4,
            itemBuilder: (_, __) => const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: ShimmerCard(),
            ),
          );
        }
        final items = controller.allEntries;
        if (items.isEmpty) {
          return const EmptyState(
            title: 'No achievements yet',
            message: 'Achievements and recognitions will appear here.',
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          itemBuilder: (_, i) {
            final entry = items[i];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.grey200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(entry.name, style: AppTextStyles.titleSmall),
                  const SizedBox(height: 4),
                  Text(entry.institution, style: AppTextStyles.caption),
                  const SizedBox(height: 6),
                  Text(entry.achievement, style: AppTextStyles.bodySmall),
                ],
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(Routes.addAchievement),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Achievement', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
