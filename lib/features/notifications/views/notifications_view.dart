import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/kerala_app_bar.dart';
import '../../../data/models/citizen_notification.dart';
import '../controllers/notifications_controller.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: KeralaAppBar(title: 'Notifications'),
      body: Obx(() {
        if (controller.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.notifications.isEmpty) {
          return const _EmptyState();
        }
        return RefreshIndicator(
          onRefresh: controller.loadNotifications,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            itemCount: controller.notifications.length,
            separatorBuilder: (_, __) => const Divider(height: 1, indent: 56),
            itemBuilder: (_, i) => _NotificationTile(
              notification: controller.notifications[i],
              onTap: () => controller.onNotificationTap(controller.notifications[i]),
            ),
          ),
        );
      }),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.notification, required this.onTap});
  final CitizenNotification notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isUnread = !notification.isRead;
    return InkWell(
      onTap: onTap,
      child: Container(
        color: isUnread ? AppColors.primary.withValues(alpha: 0.04) : null,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                color: _iconBg(notification.type),
                shape: BoxShape.circle,
              ),
              child: Icon(_icon(notification.type), color: _iconColor(notification.type), size: 20.r),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: isUnread ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ),
                      if (isUnread)
                        Container(
                          width: 8.r,
                          height: 8.r,
                          margin: EdgeInsets.only(left: 8.w),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Text(notification.body, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                  SizedBox(height: 4.h),
                  Text(_timeAgo(notification.createdAt), style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _icon(String type) {
    return switch (type) {
      'issue_update' => Icons.report_rounded,
      'mla_post' => Icons.article_rounded,
      'mla_event' => Icons.event_rounded,
      'mla_announcement' => Icons.campaign_rounded,
      'emergency_alert' => Icons.warning_rounded,
      'event_reminder' => Icons.alarm_rounded,
      _ => Icons.notifications_rounded,
    };
  }

  Color _iconColor(String type) {
    return switch (type) {
      'issue_update' => AppColors.reportOrange,
      'mla_post' => AppColors.primary,
      'mla_event' => AppColors.improveBlue,
      'mla_announcement' => AppColors.primary,
      'emergency_alert' => AppColors.statusRejected,
      'event_reminder' => AppColors.improveBlue,
      _ => AppColors.primary,
    };
  }

  Color _iconBg(String type) {
    return switch (type) {
      'issue_update' => AppColors.reportOrangeLight,
      'mla_post' => AppColors.ideaPurpleLight,
      'mla_event' => AppColors.improveBlueLight,
      'mla_announcement' => AppColors.ideaPurpleLight,
      'emergency_alert' => AppColors.statusRejectedBg,
      'event_reminder' => AppColors.improveBlueLight,
      _ => AppColors.surfaceVariant,
    };
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80.r,
            height: 80.r,
            decoration: const BoxDecoration(color: AppColors.surfaceVariant, shape: BoxShape.circle),
            child: Icon(Icons.notifications_none_rounded, size: 40.r, color: AppColors.primary),
          ),
          SizedBox(height: 20.h),
          const Text('No notifications yet', style: AppTextStyles.titleMedium),
          SizedBox(height: 8.h),
          const Text(
            'Updates about your submissions\nwill appear here.',
            style: AppTextStyles.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
