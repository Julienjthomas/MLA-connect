import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/kerala_app_bar.dart';
import '../../../core/widgets/primary_button.dart';
import '../controllers/notifications_setup_controller.dart';

class NotificationsSetupView extends GetView<NotificationsSetupController> {
  const NotificationsSetupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KeralaAppBar(title: AppStrings.notificationPrefs),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppStrings.notificationPrefs, style: AppTextStyles.headlineSmall),
              SizedBox(height: 4.h),
              Text(AppStrings.notificationSubtitle, style: AppTextStyles.bodySmall),
              SizedBox(height: 28.h),
              Obx(
                () => Column(
                  children: [
                    _notifTile(
                      icon: Icons.notifications_outlined,
                      iconColor: AppColors.ideaPurple,
                      title: AppStrings.issueUpdates,
                      subtitle: AppStrings.issueUpdatesDesc,
                      value: controller.issueUpdates.value,
                      onChanged: (v) => controller.issueUpdates.value = v,
                    ),
                    SizedBox(height: 12.h),
                    _notifTile(
                      icon: Icons.campaign_outlined,
                      iconColor: AppColors.improveBlue,
                      title: AppStrings.mlaAnnouncements,
                      subtitle: AppStrings.mlaAnnouncementsDesc,
                      value: controller.mlaAnnouncements.value,
                      onChanged: (v) => controller.mlaAnnouncements.value = v,
                    ),
                    SizedBox(height: 12.h),
                    _notifTile(
                      icon: Icons.warning_amber_outlined,
                      iconColor: AppColors.reportOrange,
                      title: AppStrings.emergencyAlerts,
                      subtitle: AppStrings.emergencyAlertsDesc,
                      value: controller.emergencyAlerts.value,
                      onChanged: (v) => controller.emergencyAlerts.value = v,
                    ),
                    SizedBox(height: 12.h),
                    _notifTile(
                      icon: Icons.event_outlined,
                      iconColor: AppColors.appreciateGreen,
                      title: AppStrings.eventReminders,
                      subtitle: AppStrings.eventRemindersDesc,
                      value: controller.eventReminders.value,
                      onChanged: (v) => controller.eventReminders.value = v,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Obx(
                () => PrimaryButton(
                  text: AppStrings.next,
                  onPressed: controller.finish,
                  isLoading: controller.loading.value,
                ),
              ),
              SizedBox(height: 12.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _notifTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Row(
        children: [
          Container(
            width: 36.r,
            height: 36.r,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, color: iconColor, size: 18.r),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.titleSmall),
                Text(subtitle, style: AppTextStyles.caption),
              ],
            ),
          ),
          Switch.adaptive(value: value, onChanged: onChanged, activeThumbColor: AppColors.primary),
        ],
      ),
    );
  }
}
