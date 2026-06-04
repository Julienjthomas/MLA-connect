import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
            padding: EdgeInsets.all(16.r),
            itemCount: controller.entries.length,
            separatorBuilder: (_, __) => SizedBox(height: 8.h),
            itemBuilder: (_, i) {
              final entry = controller.entries[i];
              final isMe = entry.citizenId == controller.currentUserId;
              final badge = controller.badgeForCount(entry.contributionCount);
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: isMe ? AppColors.primary.withValues(alpha: 0.08) : AppColors.surface,
                  borderRadius: BorderRadius.circular(14.r),
                  border: isMe ? Border.all(color: AppColors.primary.withValues(alpha: 0.3)) : null,
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 28.w,
                      child: Text(
                        '#${entry.rank}',
                        style: AppTextStyles.titleSmall.copyWith(
                          color: entry.rank <= 3 ? AppColors.primary : AppColors.textSecondary,
                          fontWeight: entry.rank <= 3 ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    CircleAvatar(
                      radius: 22.r,
                      backgroundColor: AppColors.surfaceVariant,
                      child: entry.avatarUrl != null && entry.avatarUrl!.isNotEmpty
                          ? ClipOval(child: CachedNetworkImage(imageUrl: entry.avatarUrl!, fit: BoxFit.cover))
                          : Text(
                              entry.name.isNotEmpty ? entry.name[0].toUpperCase() : 'C',
                              style: AppTextStyles.titleSmall.copyWith(color: AppColors.primary),
                            ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(entry.name, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                              if (isMe) ...[
                                SizedBox(width: 6.w),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                                  decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(20.r)),
                                  child: Text('You', style: TextStyle(color: Colors.white, fontSize: 11.sp)),
                                ),
                              ],
                            ],
                          ),
                          if (badge != null) ...[
                            SizedBox(height: 2.h),
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
