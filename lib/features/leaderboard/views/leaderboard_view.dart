import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/kerala_app_bar.dart';
import '../controllers/leaderboard_controller.dart';

class LeaderboardView extends GetView<LeaderboardController> {
  const LeaderboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: KeralaAppBar(title: 'Leaderboard'),
      body: Obx(() {
        if (controller.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.entries.isEmpty) {
          return const Center(child: Text('No leaderboard data yet.', style: AppTextStyles.bodyMedium));
        }
        return RefreshIndicator(
          onRefresh: controller.loadLeaderboard,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: controller.entries.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, i) {
              final entry = controller.entries[i];
              final isMe = entry.citizenId == controller.currentUserId;
              final badge = controller.badgeForCount(entry.contributionCount);
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: isMe ? AppColors.primary.withValues(alpha: 0.08) : AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: isMe ? Border.all(color: AppColors.primary.withValues(alpha: 0.3)) : null,
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 28,
                      child: Text(
                        '#${entry.rank}',
                        style: AppTextStyles.titleSmall.copyWith(
                          color: entry.rank <= 3 ? AppColors.primary : AppColors.textSecondary,
                          fontWeight: entry.rank <= 3 ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: AppColors.surfaceVariant,
                      child: entry.avatarUrl != null && entry.avatarUrl!.isNotEmpty
                          ? ClipOval(child: CachedNetworkImage(imageUrl: entry.avatarUrl!, fit: BoxFit.cover))
                          : Text(
                              entry.name.isNotEmpty ? entry.name[0].toUpperCase() : 'C',
                              style: AppTextStyles.titleSmall.copyWith(color: AppColors.primary),
                            ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(entry.name, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                              if (isMe) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(20)),
                                  child: const Text('You', style: TextStyle(color: Colors.white, fontSize: 11)),
                                ),
                              ],
                            ],
                          ),
                          if (badge != null) ...[
                            const SizedBox(height: 2),
                            Text('${badge.emoji} ${badge.name}', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                          ],
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${entry.contributionCount}',
                          style: AppTextStyles.titleMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700),
                        ),
                        Text('contributions', style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary)),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
