import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_enums.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/comments_section.dart';
import '../../../core/widgets/kerala_app_bar.dart';
import '../../../core/widgets/shimmer_loader.dart';
import '../../../data/models/appreciation_model.dart';
import '../../../data/remote/appreciation_api.dart';
import '../../../routes/app_routes.dart';
import '../../auth/controllers/auth_controller.dart';

class AppreciationDetailView extends StatelessWidget {
  const AppreciationDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final appreciation = Get.arguments as AppreciationModel?;
    final uid = Get.isRegistered<AuthController>() ? Get.find<AuthController>().userId : null;
    final isOwn = uid != null && appreciation?.userId == uid;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: KeralaAppBar(
        title: AppStrings.appreciationDetail,
        actions: isOwn && appreciation != null
            ? [
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, color: AppColors.statusRejected),
                  onPressed: () => _confirmDeleteAppreciation(context, appreciation),
                ),
              ]
            : null,
      ),
      body: appreciation == null
          ? Center(child: ShimmerBox(height: 200.h))
          : _AppreciationDetailBody(appreciation: appreciation),
    );
  }
}

void _confirmDeleteAppreciation(BuildContext context, AppreciationModel appreciation) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Delete Appreciation?'),
      content: const Text('This will permanently delete your appreciation.'),
      actions: [
        TextButton(onPressed: Get.back, child: const Text('Cancel')),
        TextButton(
          onPressed: () async {
            Get.back();
            try {
              await Get.find<AppreciationApi>().deleteAppreciation(appreciation.id);
              Get.back(result: true);
            } catch (_) {
              Get.snackbar('Error', 'Could not delete. Try again.', snackPosition: SnackPosition.BOTTOM);
            }
          },
          child: const Text('Delete', style: TextStyle(color: AppColors.statusRejected)),
        ),
      ],
    ),
  );
}

class _AppreciationDetailBody extends StatelessWidget {
  final AppreciationModel appreciation;
  const _AppreciationDetailBody({required this.appreciation});

  @override
  Widget build(BuildContext context) {
    final shortId = appreciation.id.length > 6
        ? appreciation.id.substring(appreciation.id.length - 6).toUpperCase()
        : appreciation.id.toUpperCase();
    final title = appreciation.staffName != null && appreciation.staffName!.isNotEmpty
        ? appreciation.staffName!
        : appreciation.categoryLabel;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 32.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StatusBanner(status: appreciation.status),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16.r)),
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
                    Text('ID: $shortId', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                    Container(margin: EdgeInsets.symmetric(horizontal: 10.w), width: 1, height: 14.h, color: AppColors.grey300),
                    Icon(Icons.calendar_today_outlined, size: 14.r, color: AppColors.grey400),
                    SizedBox(width: 4.w),
                    Text(appreciation.timeAgo, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
                if (appreciation.recipientCategory.isNotEmpty) ...[
                  SizedBox(height: 12.h),
                  const Divider(height: 1),
                  SizedBox(height: 12.h),
                  Text(AppStrings.recipientCategory, style: AppTextStyles.labelMedium.copyWith(color: AppColors.textTertiary)),
                  SizedBox(height: 4.h),
                  Text(appreciation.categoryLabel, style: AppTextStyles.bodyMedium),
                ],
                if (appreciation.department != null && appreciation.department!.isNotEmpty) ...[
                  SizedBox(height: 12.h),
                  const Divider(height: 1),
                  SizedBox(height: 12.h),
                  Text(AppStrings.selectCategory, style: AppTextStyles.labelMedium.copyWith(color: AppColors.textTertiary)),
                  SizedBox(height: 4.h),
                  Text(appreciation.department!, style: AppTextStyles.bodyMedium),
                ],
                if (appreciation.message.trim().isNotEmpty) ...[
                  SizedBox(height: 12.h),
                  const Divider(height: 1),
                  SizedBox(height: 12.h),
                  Text(AppStrings.yourAppreciation, style: AppTextStyles.labelMedium.copyWith(color: AppColors.textTertiary)),
                  SizedBox(height: 4.h),
                  Text(appreciation.message, style: AppTextStyles.bodyMedium),
                ],
                if (appreciation.relatedWork != null && appreciation.relatedWork!.isNotEmpty) ...[
                  SizedBox(height: 12.h),
                  const Divider(height: 1),
                  SizedBox(height: 12.h),
                  Text(AppStrings.relatedWork, style: AppTextStyles.labelMedium.copyWith(color: AppColors.textTertiary)),
                  SizedBox(height: 4.h),
                  Text(appreciation.relatedWork!, style: AppTextStyles.bodyMedium),
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
                final comments = await Get.find<AppreciationApi>().getComments(cid, appreciation.id);
                return comments.map((c) => CommentEntry(
                  id: c.id, authorId: c.citizenId, authorName: c.citizenId, body: c.body, createdAt: c.createdAt,
                )).toList();
              },
              onPost: (text) async {
                final cid = Get.find<AuthController>().user.value?.constituencyId ?? '';
                await Get.find<AppreciationApi>().addComment(cid, appreciation.id, {'body': text});
              },
              onDelete: (commentId) async {
                final cid = Get.find<AuthController>().user.value?.constituencyId ?? '';
                await Get.find<AppreciationApi>().deleteComment(cid, appreciation.id, commentId);
              },
            ),
          ),
          SizedBox(height: 16.h),
          _NeedHelpTile(),
        ],
      ),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  final SubmissionStatus status;
  const _StatusBanner({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(color: status.bgColor, borderRadius: BorderRadius.circular(16.r)),
      child: Row(
        children: [
          Container(
            width: 44.r,
            height: 44.r,
            decoration: BoxDecoration(color: status.color.withValues(alpha: 0.15), shape: BoxShape.circle),
            child: Icon(Icons.favorite_outline_rounded, color: AppColors.primary, size: 22.r),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('STATUS', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textTertiary, letterSpacing: 0.8)),
                SizedBox(height: 2.h),
                Row(children: [
                  Icon(Icons.circle, size: 8.r, color: status.color),
                  SizedBox(width: 6.w),
                  Text(status.label, style: AppTextStyles.titleSmall.copyWith(color: status.color)),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NeedHelpTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.chat),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14.r)),
        child: Row(
          children: [
            Icon(Icons.headset_mic_outlined, size: 22.r, color: AppColors.primary),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppStrings.needHelp, style: AppTextStyles.titleSmall),
                  Text(AppStrings.needHelpSubtitle, style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, size: 20.r, color: AppColors.grey400),
          ],
        ),
      ),
    );
  }
}
