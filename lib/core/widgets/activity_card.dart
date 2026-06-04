import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: imageUrl != null
                  ? SubmissionMediaImage(
                      reference: imageUrl!,
                      width: 72.r,
                      height: 72.r,
                      borderRadius: BorderRadius.circular(10.r),
                      placeholder: _placeholder(),
                      errorWidget: _placeholder(),
                    )
                  : _placeholder(),
            ),
            SizedBox(width: 12.w),
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
                    SizedBox(height: 6.h),
                    statusWidget ?? StatusChip(status: status!),
                  ],
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined, size: 12.r, color: AppColors.grey400),
                      SizedBox(width: 4.w),
                      Text(timeAgo, style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary)),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Icon(Icons.chevron_right_rounded, size: 20.r, color: AppColors.grey400),
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
      width: 72.r,
      height: 72.r,
      color: bg,
      child: Icon(icon, color: color, size: 28.r),
    );
  }
}
