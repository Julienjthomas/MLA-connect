import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

const _badgeTiers = [
  (name: 'Legend', minCount: 50, emoji: '🏆'),
  (name: 'Leader', minCount: 25, emoji: '⭐'),
  (name: 'Champion', minCount: 10, emoji: '🥇'),
  (name: 'Active', minCount: 5, emoji: '🔥'),
  (name: 'Starter', minCount: 1, emoji: '🌱'),
];

class BadgesWidget extends StatelessWidget {
  const BadgesWidget({super.key, required this.contributionCount});
  final int contributionCount;

  @override
  Widget build(BuildContext context) {
    final earned = _badgeTiers.where((t) => contributionCount >= t.minCount).toList();

    if (earned.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
        child: const Text(
          'Submit your first contribution to earn a badge.',
          style: AppTextStyles.bodySmall,
          textAlign: TextAlign.center,
        ),
      );
    }

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: earned
          .map((t) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(t.emoji, style: const TextStyle(fontSize: 18)),
                    const SizedBox(width: 6),
                    Text(t.name, style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary)),
                  ],
                ),
              ))
          .toList(),
    );
  }
}
