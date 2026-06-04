import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

const _options = [
  (value: 'public', label: 'Public', desc: 'Visible to all citizens in your constituency', icon: Icons.public_rounded),
  (value: 'anonymous', label: 'Anonymous', desc: 'Visible but your name is hidden', icon: Icons.person_off_rounded),
  (value: 'private', label: 'Private', desc: 'Only visible to you and MLA office', icon: Icons.lock_outline_rounded),
];

/// Shows a bottom sheet for picking submission visibility.
/// Returns the selected value ('public', 'anonymous', 'private') or null if dismissed.
Future<String?> showVisibilityPicker(BuildContext context, {String? current}) {
  return showModalBottomSheet<String>(
    context: context,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (_) => SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36, height: 4,
                decoration: BoxDecoration(color: AppColors.grey300, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Change Visibility', style: AppTextStyles.titleMedium),
            const SizedBox(height: 16),
            ..._options.map((opt) => _VisibilityTile(
              option: opt,
              selected: opt.value == (current ?? 'public'),
              onTap: () => Get.back(result: opt.value),
            )),
            const SizedBox(height: 8),
          ],
        ),
      ),
    ),
  );
}

class _VisibilityTile extends StatelessWidget {
  const _VisibilityTile({required this.option, required this.selected, required this.onTap});
  final ({String value, String label, String desc, IconData icon}) option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary.withValues(alpha: 0.06) : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? AppColors.primary : AppColors.grey300, width: selected ? 2 : 1),
        ),
        child: Row(
          children: [
            Icon(option.icon, color: selected ? AppColors.primary : AppColors.grey500, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(option.label, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                  Text(option.desc, style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary)),
                ],
              ),
            ),
            if (selected) const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 20),
          ],
        ),
      ),
    );
  }
}
