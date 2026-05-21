import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_enums.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/kerala_app_bar.dart';
import '../../../core/widgets/shimmer_loader.dart';
import '../../../data/models/appreciation_model.dart';
import '../../../routes/app_routes.dart';

class AppreciationDetailView extends StatelessWidget {
  const AppreciationDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final appreciation = Get.arguments as AppreciationModel?;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: KeralaAppBar(title: AppStrings.appreciationDetail),
      body: appreciation == null
          ? const Center(child: ShimmerBox(height: 200))
          : _AppreciationDetailBody(appreciation: appreciation),
    );
  }
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
        : appreciation.recipientCategory;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StatusBanner(status: appreciation.status),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16)),
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
                    Text('ID: $shortId', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                    Container(margin: const EdgeInsets.symmetric(horizontal: 10), width: 1, height: 14, color: AppColors.grey300),
                    const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.grey400),
                    const SizedBox(width: 4),
                    Text(appreciation.timeAgo, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
                if (appreciation.recipientCategory.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  Text(AppStrings.recipientCategory, style: AppTextStyles.labelMedium.copyWith(color: AppColors.textTertiary)),
                  const SizedBox(height: 4),
                  Text(appreciation.recipientCategory, style: AppTextStyles.bodyMedium),
                ],
                if (appreciation.department != null && appreciation.department!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  Text(AppStrings.selectCategory, style: AppTextStyles.labelMedium.copyWith(color: AppColors.textTertiary)),
                  const SizedBox(height: 4),
                  Text(appreciation.department!, style: AppTextStyles.bodyMedium),
                ],
                if (appreciation.message.trim().isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  Text(AppStrings.yourAppreciation, style: AppTextStyles.labelMedium.copyWith(color: AppColors.textTertiary)),
                  const SizedBox(height: 4),
                  Text(appreciation.message, style: AppTextStyles.bodyMedium),
                ],
                if (appreciation.relatedWork != null && appreciation.relatedWork!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  Text(AppStrings.relatedWork, style: AppTextStyles.labelMedium.copyWith(color: AppColors.textTertiary)),
                  const SizedBox(height: 4),
                  Text(appreciation.relatedWork!, style: AppTextStyles.bodyMedium),
                ],
              ],
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
            child: const Icon(Icons.favorite_outline_rounded, color: AppColors.primary, size: 22),
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
