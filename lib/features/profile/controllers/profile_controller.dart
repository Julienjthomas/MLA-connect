import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../auth/controllers/auth_controller.dart';

class ProfileController extends GetxController {
  final _auth = Get.find<AuthController>();

  final RxBool notifyIssueUpdates = true.obs;
  final RxBool notifyMlaAnnouncements = true.obs;
  final RxBool notifyEmergencyAlerts = true.obs;
  final RxBool notifyEventReminders = false.obs;

  String get userName => _auth.user.value?.name ?? 'User';
  String? get userPhone => _auth.user.value?.phone;
  String? get userAvatar => _auth.user.value?.avatarUrl;
  String? get wardName => _auth.user.value?.wardName;
  String? get localBodyName => _auth.user.value?.localBodyName;
  String? get constituencyName => _auth.user.value?.constituencyName;

  Future<void> logout() => _auth.logout();

  Future<void> pickLanguage(BuildContext context) async {
    final current = _auth.user.value?.language ?? 'en';
    await showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(color: AppColors.grey300, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Language', style: AppTextStyles.titleMedium),
            const SizedBox(height: 16),
            _langTile(ctx, 'en', 'English', current),
            const SizedBox(height: 10),
            _langTile(ctx, 'ml', 'മലയാളം (Malayalam)', current),
          ],
        ),
      ),
    );
  }

  Widget _langTile(BuildContext context, String code, String label, String current) {
    final selected = current == code;
    return GestureDetector(
      onTap: () async {
        await _auth.updateLanguage(code);
        if (context.mounted) Navigator.pop(context);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary.withValues(alpha: 0.08) : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? AppColors.primary : AppColors.grey300, width: selected ? 2 : 1),
        ),
        child: Row(
          children: [
            Expanded(child: Text(label, style: AppTextStyles.titleSmall)),
            if (selected) const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 20),
          ],
        ),
      ),
    );
  }
}
