import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/empty_state.dart';

class AchievementsListingView extends StatelessWidget {
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
      body: const EmptyState(
        title: 'No achievements yet',
        message: 'Achievements and recognitions will appear here.',
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Achievement', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
