import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_enums.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/comments_section.dart';
import '../../../core/widgets/kerala_app_bar.dart';
import '../../../core/widgets/shimmer_loader.dart';
import '../../../core/widgets/submission_media_image.dart';
import '../../../data/models/idea_model.dart';
import '../../../data/remote/idea_api.dart';
import '../../../routes/app_routes.dart';
import '../../auth/controllers/auth_controller.dart';

class IdeaDetailView extends StatelessWidget {
  const IdeaDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final idea = Get.arguments as IdeaModel?;
    final uid = Get.isRegistered<AuthController>() ? Get.find<AuthController>().userId : null;
    final isOwn = uid != null && idea?.userId == uid;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: KeralaAppBar(
        title: AppStrings.ideaDetail,
        actions: isOwn && idea != null
            ? [
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, color: AppColors.statusRejected),
                  onPressed: () => _confirmDeleteIdea(context, idea),
                ),
              ]
            : null,
      ),
      body: idea == null
          ? const Center(child: ShimmerBox(height: 200))
          : _IdeaDetailBody(idea: idea),
    );
  }
}

void _confirmDeleteIdea(BuildContext context, IdeaModel idea) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Delete Idea?'),
      content: const Text('This will permanently delete your idea.'),
      actions: [
        TextButton(onPressed: Get.back, child: const Text('Cancel')),
        TextButton(
          onPressed: () async {
            Get.back();
            try {
              await Get.find<IdeaApi>().deleteIdea(idea.id);
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

class _IdeaDetailBody extends StatelessWidget {
  final IdeaModel idea;
  const _IdeaDetailBody({required this.idea});

  @override
  Widget build(BuildContext context) {
    final shortId = idea.id.length > 6
        ? idea.id.substring(idea.id.length - 6).toUpperCase()
        : idea.id.toUpperCase();
    final description = idea.description.trim();
    final benefits = idea.benefits?.trim() ?? '';

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StatusBanner(status: idea.status),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(idea.title, style: AppTextStyles.headlineSmall),
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.receipt_outlined, size: 16, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text('ID: $shortId', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                    Container(margin: const EdgeInsets.symmetric(horizontal: 10), width: 1, height: 14, color: AppColors.grey300),
                    const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.grey400),
                    const SizedBox(width: 4),
                    Text(idea.timeAgo, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
                if (idea.topic.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  Text(AppStrings.selectCategory, style: AppTextStyles.labelMedium.copyWith(color: AppColors.textTertiary)),
                  const SizedBox(height: 4),
                  Text(idea.topic, style: AppTextStyles.bodyMedium),
                ],
                if (description.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  Text(AppStrings.description, style: AppTextStyles.labelMedium.copyWith(color: AppColors.textTertiary)),
                  const SizedBox(height: 4),
                  Text(description, style: AppTextStyles.bodyMedium),
                ],
                if (benefits.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  Text(AppStrings.keyBenefits, style: AppTextStyles.labelMedium.copyWith(color: AppColors.textTertiary)),
                  const SizedBox(height: 4),
                  Text(benefits, style: AppTextStyles.bodyMedium),
                ],
                if (idea.mediaUrls.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  Text('${AppStrings.photos} (${idea.mediaUrls.length})', style: AppTextStyles.labelMedium.copyWith(color: AppColors.textTertiary)),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 160,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: idea.mediaUrls.length,
                      itemBuilder: (_, i) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: SubmissionMediaImage(
                          reference: idea.mediaUrls[i],
                          width: 160,
                          height: 160,
                          borderRadius: BorderRadius.circular(12),
                          placeholder: Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(color: AppColors.grey200, borderRadius: BorderRadius.circular(12)),
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
          Container(
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16)),
            child: CommentsSection(
              onLoad: () async {
                final cid = Get.find<AuthController>().user.value?.constituencyId ?? '';
                final comments = await Get.find<IdeaApi>().getComments(cid, idea.id);
                return comments.map((c) => CommentEntry(
                  id: c.id, authorId: c.citizenId, authorName: c.citizenId, body: c.body, createdAt: c.createdAt,
                )).toList();
              },
              onPost: (text) async {
                final cid = Get.find<AuthController>().user.value?.constituencyId ?? '';
                await Get.find<IdeaApi>().addComment(cid, idea.id, {'body': text});
              },
              onDelete: (commentId) async {
                final cid = Get.find<AuthController>().user.value?.constituencyId ?? '';
                await Get.find<IdeaApi>().deleteComment(cid, idea.id, commentId);
              },
            ),
          ),
          const SizedBox(height: 16),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: status.bgColor, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: status.color.withValues(alpha: 0.15), shape: BoxShape.circle),
            child: const Icon(Icons.lightbulb_outline_rounded, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('STATUS', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textTertiary, letterSpacing: 0.8)),
                const SizedBox(height: 2),
                Row(children: [
                  Icon(Icons.circle, size: 8, color: status.color),
                  const SizedBox(width: 6),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14)),
        child: Row(
          children: [
            const Icon(Icons.headset_mic_outlined, size: 22, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppStrings.needHelp, style: AppTextStyles.titleSmall),
                  Text(AppStrings.needHelpSubtitle, style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, size: 20, color: AppColors.grey400),
          ],
        ),
      ),
    );
  }
}
