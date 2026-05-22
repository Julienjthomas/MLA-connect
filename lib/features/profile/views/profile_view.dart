import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../routes/app_routes.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        automaticallyImplyLeading: false,
        leadingWidth: 0,
        centerTitle: false,
        leading: const SizedBox.shrink(),
        title: Text(AppStrings.myProfile, style: AppTextStyles.titleLarge),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.divider),
        ),
      ),
      body: ListView(
        children: [
          _UserCard(controller: controller),
          const SizedBox(height: 8),
          _ChatWithMlaCard(),
          const SizedBox(height: 8),
          _SectionLabel(AppStrings.notifications),
          _NotificationTiles(controller: controller),
          const SizedBox(height: 8),
          _SectionLabel(AppStrings.general),
          _SettingsTile(
            icon: Icons.language_outlined,
            title: AppStrings.language,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Obx(() {
                  final lang = Get.find<AuthController>().user.value?.language ?? 'en';
                  final label = lang == 'ml' ? 'മലയാളം' : 'English';
                  return Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13));
                }),
                const Icon(Icons.chevron_right, color: AppColors.grey400, size: 20),
              ],
            ),
            onTap: () => controller.pickLanguage(context),
          ),
          _SettingsTile(
            icon: Icons.help_outline_rounded,
            title: AppStrings.helpFaq,
            onTap: () => Get.toNamed(Routes.helpFaq),
          ),
          _SettingsTile(
            icon: Icons.phone_outlined,
            title: AppStrings.contactMlaOffice,
            onTap: () => Get.toNamed(Routes.contactMlaOffice),
          ),
          _SettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: AppStrings.privacyPolicy,
            onTap: () => Get.toNamed(Routes.privacyPolicy),
          ),
          const SizedBox(height: 8),
          _SectionLabel(AppStrings.account),
          _SettingsTile(
            icon: Icons.logout_rounded,
            title: AppStrings.logout,
            titleColor: AppColors.statusRejected,
            iconColor: AppColors.statusRejected,
            onTap: () => _confirmLogout(context),
          ),
          const SizedBox(height: 40),
          Center(
            child: Text(
              '${AppStrings.appName} v1.0.0',
              style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              controller.logout();
            },
            child: const Text('Logout', style: TextStyle(color: AppColors.statusRejected)),
          ),
        ],
      ),
    );
  }
}

class _ChatWithMlaCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Get.toNamed(Routes.chat),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
                  child: const Icon(Icons.account_balance_rounded, color: AppColors.primary, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(AppStrings.chatWithYourMla, style: AppTextStyles.titleSmall)],
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () => Get.toNamed(Routes.chat),
                  icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16),
                  label: const Text('Start Chat'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    textStyle: AppTextStyles.labelMedium,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  final ProfileController controller;
  const _UserCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Obx(() {
        final avatar = controller.userAvatar;
        return Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surfaceVariant,
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 2),
              ),
              child: ClipOval(
                child: avatar != null && avatar.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: avatar,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => _defaultAvatar(controller.userName),
                      )
                    : _defaultAvatar(controller.userName),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(controller.userName, style: AppTextStyles.titleMedium),
                  if (controller.userPhone != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      controller.userPhone!.startsWith('+') ? controller.userPhone! : '+91 ${controller.userPhone!}',
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                  if (controller.wardName != null || controller.localBodyName != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 13, color: AppColors.primary),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            [
                              if (controller.localBodyName != null) controller.localBodyName!,
                              if (controller.wardName != null) controller.wardName!,
                            ].join(' · '),
                            style: AppTextStyles.caption.copyWith(color: AppColors.primary),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 20, color: AppColors.textSecondary),
              onPressed: () => Get.toNamed(Routes.profileEdit),
            ),
          ],
        );
      }),
    );
  }

  Widget _defaultAvatar(String name) {
    final initials = name.trim().split(' ').map((w) => w.isNotEmpty ? w[0] : '').take(2).join().toUpperCase();
    return Container(
      color: AppColors.surfaceVariant,
      child: Center(
        child: Text(
          initials.isEmpty ? 'U' : initials,
          style: AppTextStyles.titleMedium.copyWith(color: AppColors.primary),
        ),
      ),
    );
  }
}

class _NotificationTiles extends StatelessWidget {
  final ProfileController controller;
  const _NotificationTiles({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      child: Obx(
        () => Column(
          children: [
            _SwitchTile(
              icon: Icons.notifications_active_outlined,
              title: 'Issue Updates',
              subtitle: 'Updates on your reported issues',
              value: controller.notifyIssueUpdates.value,
              onChanged: (v) => controller.notifyIssueUpdates.value = v,
            ),
            _SwitchTile(
              icon: Icons.campaign_outlined,
              title: 'MLA Announcements',
              subtitle: 'Important announcements from MLA',
              value: controller.notifyMlaAnnouncements.value,
              onChanged: (v) => controller.notifyMlaAnnouncements.value = v,
            ),
            _SwitchTile(
              icon: Icons.warning_amber_rounded,
              title: 'Emergency Alerts',
              subtitle: 'Alerts on urgent situations',
              value: controller.notifyEmergencyAlerts.value,
              onChanged: (v) => controller.notifyEmergencyAlerts.value = v,
            ),
            _SwitchTile(
              icon: Icons.event_outlined,
              title: 'Event Reminders',
              subtitle: 'Upcoming events & programs',
              value: controller.notifyEventReminders.value,
              onChanged: (v) => controller.notifyEventReminders.value = v,
              showDivider: false,
            ),
          ],
        ),
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool showDivider;

  const _SwitchTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: AppColors.primary, size: 22),
          title: Text(title, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500)),
          subtitle: Text(subtitle, style: AppTextStyles.caption),
          trailing: Switch.adaptive(value: value, onChanged: onChanged, activeThumbColor: AppColors.primary),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        ),
        if (showDivider) const Divider(height: 1, indent: 56, endIndent: 16),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final Color? titleColor;
  final Color? iconColor;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.trailing,
    this.titleColor,
    this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      child: ListTile(
        leading: Icon(icon, color: iconColor ?? AppColors.textSecondary, size: 22),
        title: Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(color: titleColor, fontWeight: FontWeight.w500),
        ),
        trailing: trailing ?? const Icon(Icons.chevron_right, color: AppColors.grey400, size: 20),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        label.toUpperCase(),
        style: AppTextStyles.caption.copyWith(
          color: AppColors.textTertiary,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
