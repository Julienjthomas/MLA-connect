import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../constants/app_enums.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'status_chip.dart';

class ActivityCard extends StatelessWidget {
  final String title;
  final String id;
  final String ward;
  final SubmissionStatus status;
  final String timeAgo;
  final String? imageUrl;
  final VoidCallback? onTap;
  final VoidCallback? onMore;

  const ActivityCard({
    super.key,
    required this.title,
    required this.id,
    required this.ward,
    required this.status,
    required this.timeAgo,
    this.imageUrl,
    this.onTap,
    this.onMore,
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
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: imageUrl!,
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => _placeholder(),
                    )
                  : _placeholder(),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(title, style: AppTextStyles.titleMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
                      ),
                      if (onMore != null)
                        GestureDetector(
                          onTap: onMore,
                          child: const Icon(Icons.more_vert, size: 18, color: AppColors.grey500),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ID: $id  •  $ward',
                    style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      StatusChip(status: status),
                      const Spacer(),
                      Text(timeAgo, style: AppTextStyles.caption),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 64,
      height: 64,
      color: AppColors.grey100,
      child: const Icon(Icons.image_outlined, color: AppColors.grey400, size: 28),
    );
  }
}
