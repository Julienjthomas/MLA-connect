import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          return Padding(
            padding: EdgeInsets.all(20.r),
            child: Column(
              children: [
                ShimmerBox(height: 100.h),
                SizedBox(height: 12.h),
                ShimmerBox(height: 120.h),
                SizedBox(height: 12.h),
                ShimmerBox(height: 200.h),
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
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 32.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _StatusBanner(status: report.status),
              SizedBox(height: 16.h),

              Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.headlineSmall),
                    SizedBox(height: 12.h),
                    const Divider(height: 1),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Icon(Icons.receipt_outlined, size: 16.r, color: AppColors.primary),
                        SizedBox(width: 6.w),
                        Text(
                          'ID: ${report.shortId}',
                          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10.w),
                          width: 1,
                          height: 14.h,
                          color: AppColors.grey300,
                        ),
                        Icon(Icons.calendar_today_outlined, size: 14.r, color: AppColors.grey400),
                        SizedBox(width: 4.w),
                        Text(
                          report.timeAgo,
                          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                    if (showDescription) ...[
                      SizedBox(height: 16.h),
                      const Divider(height: 1),
                      SizedBox(height: 12.h),
                      Text(AppStrings.description, style: AppTextStyles.labelMedium.copyWith(color: AppColors.textTertiary)),
                      SizedBox(height: 6.h),
                      Text(description, style: AppTextStyles.bodyMedium),
                    ],
                    if (report.mediaUrls.isNotEmpty) ...[
                      SizedBox(height: 16.h),
                      const Divider(height: 1),
                      SizedBox(height: 12.h),
                      Text(
                        '${AppStrings.photos} (${report.mediaUrls.length})',
                        style: AppTextStyles.labelMedium.copyWith(color: AppColors.textTertiary),
                      ),
                      SizedBox(height: 10.h),
                      SizedBox(
                        height: 160.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: report.mediaUrls.length,
                          itemBuilder: (_, i) => Padding(
                            padding: EdgeInsets.only(right: 8.w),
                            child: SubmissionMediaImage(
                              reference: report.mediaUrls[i],
                              width: 160.w,
                              height: 160.h,
                              borderRadius: BorderRadius.circular(12.r),
                              placeholder: Container(
                                width: 160.w,
                                height: 160.h,
                                decoration: BoxDecoration(
                                  color: AppColors.grey200,
                                  borderRadius: BorderRadius.circular(12.r),
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

              SizedBox(height: 16.h),

              Container(
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16.r)),
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

              SizedBox(height: 16.h),

              GestureDetector(
                onTap: () => Get.toNamed(Routes.chat),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.headset_mic_outlined, size: 22.r, color: AppColors.primary),
                      SizedBox(width: 12.w),
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
                      Icon(Icons.chevron_right_rounded, size: 20.r, color: AppColors.grey400),
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
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: status.bgColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Container(
            width: 44.r,
            height: 44.r,
            decoration: BoxDecoration(
              color: status.color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.report_rounded, color: AppColors.primary, size: 22.r),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'STATUS',
                  style: AppTextStyles.labelSmall.copyWith(color: AppColors.textTertiary, letterSpacing: 0.8),
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Icon(Icons.circle, size: 8.r, color: status.color),
                    SizedBox(width: 6.w),
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
