import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/kerala_app_bar.dart';
import '../../../core/widgets/comments_section.dart';
import '../../../core/widgets/shimmer_loader.dart';
import '../../../core/widgets/submission_media_image.dart';
import '../../../core/constants/app_enums.dart';
import '../../../data/models/concern/concern_comment.dart';
import '../../../data/remote/concern_api.dart';
import '../../../routes/app_routes.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/report_detail_controller.dart';

class ReportDetailView extends GetView<ReportDetailController> {
  const ReportDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: KeralaAppBar(
        title: AppStrings.reportDetail,
        actions: [
          Obx(() => controller.isOwn
              ? IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, color: AppColors.statusRejected),
                  onPressed: controller.deleting.value ? null : () => _showDeleteDialog(context),
                )
              : const SizedBox.shrink()),
        ],
      ),
      body: Obx(() {
        if (controller.loading.value) {
          return const Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                ShimmerBox(height: 100),
                SizedBox(height: 12),
                ShimmerBox(height: 120),
                SizedBox(height: 12),
                ShimmerBox(height: 200),
              ],
            ),
          );
        }
        final report = controller.report.value;
        if (report == null) return Center(child: Text(AppStrings.reportNotFound));
        final description = report.description.trim();
        final title = report.title.trim();
        final showDescription = description.isNotEmpty && description != title;

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status banner
              _StatusBanner(status: report.status),
              const SizedBox(height: 16),

              // Main detail card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.headlineSmall),
                    const SizedBox(height: 12),
                    const Divider(height: 1),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.receipt_outlined, size: 16, color: AppColors.primary),
                        const SizedBox(width: 6),
                        Text(
                          'ID: ${report.shortId}',
                          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          width: 1,
                          height: 14,
                          color: AppColors.grey300,
                        ),
                        const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.grey400),
                        const SizedBox(width: 4),
                        Text(
                          report.timeAgo,
                          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                    if (showDescription) ...[
                      const SizedBox(height: 16),
                      const Divider(height: 1),
                      const SizedBox(height: 12),
                      Text(AppStrings.description, style: AppTextStyles.labelMedium.copyWith(color: AppColors.textTertiary)),
                      const SizedBox(height: 6),
                      Text(description, style: AppTextStyles.bodyMedium),
                    ],
                    if (report.mediaUrls.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      const Divider(height: 1),
                      const SizedBox(height: 12),
                      Text(
                        '${AppStrings.photos} (${report.mediaUrls.length})',
                        style: AppTextStyles.labelMedium.copyWith(color: AppColors.textTertiary),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 160,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: report.mediaUrls.length,
                          itemBuilder: (_, i) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: SubmissionMediaImage(
                              reference: report.mediaUrls[i],
                              width: 160,
                              height: 160,
                              borderRadius: BorderRadius.circular(12),
                              placeholder: Container(
                                width: 160,
                                height: 160,
                                decoration: BoxDecoration(
                                  color: AppColors.grey200,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Comments
              Container(
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16)),
                child: CommentsSection(
                  onLoad: () async {
                    final cid = Get.find<AuthController>().user.value?.constituencyId ?? '';
                    final concerns = await Get.find<ConcernApi>().getComments(cid, report.id);
                    return concerns.map((c) => CommentEntry(
                      id: c.id,
                      authorId: c.citizenId,
                      authorName: c.citizenId,
                      body: c.body,
                      createdAt: c.createdAt,
                    )).toList();
                  },
                  onPost: (text) async {
                    final cid = Get.find<AuthController>().user.value?.constituencyId ?? '';
                    await Get.find<ConcernApi>().addComment(cid, report.id, {'body': text});
                  },
                  onDelete: (commentId) async {
                    final cid = Get.find<AuthController>().user.value?.constituencyId ?? '';
                    await Get.find<ConcernApi>().deleteComment(cid, report.id, commentId);
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Need help
              GestureDetector(
                onTap: () => Get.toNamed(Routes.chat),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.headset_mic_outlined, size: 22, color: AppColors.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(AppStrings.needHelp, style: AppTextStyles.titleSmall),
                            Text(
                              AppStrings.needHelpSubtitle,
                              style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded, size: 20, color: AppColors.grey400),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

void _showDeleteDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Delete Report?'),
      content: const Text('This will permanently delete your report.'),
      actions: [
        TextButton(onPressed: Get.back, child: const Text('Cancel')),
        TextButton(
          onPressed: () { Get.back(); Get.find<ReportDetailController>().deleteReport(); },
          child: const Text('Delete', style: TextStyle(color: AppColors.statusRejected)),
        ),
      ],
    ),
  );
}

class _StatusBanner extends StatelessWidget {
  final SubmissionStatus status;

  const _StatusBanner({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: status.bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: status.color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.report_rounded, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'STATUS',
                  style: AppTextStyles.labelSmall.copyWith(color: AppColors.textTertiary, letterSpacing: 0.8),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(Icons.circle, size: 8, color: status.color),
                    const SizedBox(width: 6),
                    Text(
                      status.label,
                      style: AppTextStyles.titleSmall.copyWith(color: status.color),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
