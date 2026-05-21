import 'package:flutter/material.dart';
import '../constants/app_enums.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'status_chip.dart';
import 'submission_media_image.dart';

class ActivityCard extends StatelessWidget {
  final String title;
  final String id;
  final String? ward;
  final SubmissionStatus? status;
  final String timeAgo;
  final String? imageUrl;
  final Color? accentColor;
  final Color? accentColorLight;
  final IconData? placeholderIcon;
  final Widget? statusWidget;
  final VoidCallback? onTap;

  const ActivityCard({
    super.key,
    required this.title,
    required this.id,
    required this.timeAgo,
    this.ward,
    this.status,
    this.imageUrl,
    this.accentColor,
    this.accentColorLight,
    this.placeholderIcon,
    this.statusWidget,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: imageUrl != null
                  ? SubmissionMediaImage(
                      reference: imageUrl!,
                      width: 72,
                      height: 72,
                      borderRadius: BorderRadius.circular(10),
                      placeholder: _placeholder(),
                      errorWidget: _placeholder(),
                    )
                  : _placeholder(),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (status != null || statusWidget != null) ...[
                    const SizedBox(height: 6),
                    statusWidget ?? StatusChip(status: status!),
                  ],
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, size: 12, color: AppColors.grey400),
                      const SizedBox(width: 4),
                      Text(timeAgo, style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right_rounded, size: 20, color: AppColors.grey400),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() {
    final color = accentColor ?? AppColors.grey400;
    final bg = accentColorLight ?? AppColors.grey100;
    final icon = placeholderIcon ?? Icons.image_outlined;
    return Container(
      width: 72,
      height: 72,
      color: bg,
      child: Icon(icon, color: color, size: 28),
    );
  }
}
