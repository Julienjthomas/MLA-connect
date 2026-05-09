import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/kerala_app_bar.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../data/services/user_service.dart';
import '../../../routes/app_routes.dart';
import '../controllers/auth_controller.dart';

class NotificationsSetupView extends StatefulWidget {
  const NotificationsSetupView({super.key});

  @override
  State<NotificationsSetupView> createState() => _NotificationsSetupViewState();
}

class _NotificationsSetupViewState extends State<NotificationsSetupView> {
  bool _issueUpdates = true;
  bool _mlaAnnouncements = true;
  bool _emergencyAlerts = true;
  bool _eventReminders = false;
  bool _loading = false;

  Future<void> _finish() async {
    setState(() => _loading = true);
    try {
      final userId = Get.find<AuthController>().userId;
      if (userId != null) {
        await UserService().saveNotificationPrefs(userId, {
          'issue_updates': _issueUpdates,
          'mla_announcements': _mlaAnnouncements,
          'emergency_alerts': _emergencyAlerts,
          'event_reminders': _eventReminders,
        });
      }
      Get.offAllNamed(Routes.onboardingSuccess);
    } catch (_) {
      Get.offAllNamed(Routes.onboardingSuccess);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const KeralaAppBar(title: AppStrings.notificationPrefs),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppStrings.notificationPrefs, style: AppTextStyles.headlineSmall),
              const SizedBox(height: 4),
              Text(AppStrings.notificationSubtitle, style: AppTextStyles.bodySmall),
              const SizedBox(height: 28),
              _notifTile(
                icon: Icons.notifications_outlined,
                iconColor: AppColors.ideaPurple,
                title: AppStrings.issueUpdates,
                subtitle: AppStrings.issueUpdatesDesc,
                value: _issueUpdates,
                onChanged: (v) => setState(() => _issueUpdates = v),
              ),
              const SizedBox(height: 12),
              _notifTile(
                icon: Icons.campaign_outlined,
                iconColor: AppColors.improveBlue,
                title: AppStrings.mlaAnnouncements,
                subtitle: AppStrings.mlaAnnouncementsDesc,
                value: _mlaAnnouncements,
                onChanged: (v) => setState(() => _mlaAnnouncements = v),
              ),
              const SizedBox(height: 12),
              _notifTile(
                icon: Icons.warning_amber_outlined,
                iconColor: AppColors.reportOrange,
                title: AppStrings.emergencyAlerts,
                subtitle: AppStrings.emergencyAlertsDesc,
                value: _emergencyAlerts,
                onChanged: (v) => setState(() => _emergencyAlerts = v),
              ),
              const SizedBox(height: 12),
              _notifTile(
                icon: Icons.event_outlined,
                iconColor: AppColors.appreciateGreen,
                title: AppStrings.eventReminders,
                subtitle: AppStrings.eventRemindersDesc,
                value: _eventReminders,
                onChanged: (v) => setState(() => _eventReminders = v),
              ),
              const Spacer(),
              PrimaryButton(text: AppStrings.next, onPressed: _finish, isLoading: _loading),
              const SizedBox(height: 12),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: iconColor.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.titleSmall),
                Text(subtitle, style: AppTextStyles.caption),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
