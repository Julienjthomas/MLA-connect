import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_enums.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/kerala_app_bar.dart';
import '../../../core/widgets/shimmer_loader.dart';
import '../../../core/widgets/submission_media_image.dart';
import '../../../data/models/improvement_model.dart';
import '../../../routes/app_routes.dart';

class ImprovementDetailView extends StatelessWidget {
  const ImprovementDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final improvement = Get.arguments as ImprovementModel?;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: KeralaAppBar(title: AppStrings.improvementDetail),
      body: improvement == null
          ? Center(child: ShimmerBox(height: 200.h))
          : _ImprovementDetailBody(improvement: improvement),
    );
  }
}

class _ImprovementDetailBody extends StatelessWidget {
  final ImprovementModel improvement;
  const _ImprovementDetailBody({required this.improvement});

  @override
  Widget build(BuildContext context) {
    final shortId = improvement.id.length > 6
        ? improvement.id.substring(improvement.id.length - 6).toUpperCase()
        : improvement.id.toUpperCase();
    final title = improvement.title.isNotEmpty ? improvement.title : improvement.suggestion;
    final description = improvement.suggestion.trim();
    final showDesc = description.isNotEmpty && description != improvement.title;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 32.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StatusBanner(status: improvement.status),
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
                    Text(improvement.timeAgo, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
                if (improvement.department != null && improvement.department!.isNotEmpty) ...[
                  SizedBox(height: 12.h),
                  const Divider(height: 1),
                  SizedBox(height: 12.h),
                  Text(AppStrings.selectCategory, style: AppTextStyles.labelMedium.copyWith(color: AppColors.textTertiary)),
                  SizedBox(height: 4.h),
                  Text(improvement.department!, style: AppTextStyles.bodyMedium),
                ],
                if (showDesc) ...[
                  SizedBox(height: 12.h),
                  const Divider(height: 1),
                  SizedBox(height: 12.h),
                  Text(AppStrings.description, style: AppTextStyles.labelMedium.copyWith(color: AppColors.textTertiary)),
                  SizedBox(height: 4.h),
                  Text(description, style: AppTextStyles.bodyMedium),
                ],
                if (improvement.mediaUrls.isNotEmpty) ...[
                  SizedBox(height: 12.h),
                  const Divider(height: 1),
                  SizedBox(height: 12.h),
                  Text('${AppStrings.photos} (${improvement.mediaUrls.length})', style: AppTextStyles.labelMedium.copyWith(color: AppColors.textTertiary)),
                  SizedBox(height: 10.h),
                  SizedBox(
                    height: 160.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: improvement.mediaUrls.length,
                      itemBuilder: (_, i) => Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: SubmissionMediaImage(
                          reference: improvement.mediaUrls[i],
                          width: 160.w,
                          height: 160.h,
                          borderRadius: BorderRadius.circular(12.r),
                          placeholder: Container(
                            width: 160.w,
                            height: 160.h,
                            decoration: BoxDecoration(color: AppColors.grey200, borderRadius: BorderRadius.circular(12.r)),
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
            child: Icon(Icons.build_rounded, color: AppColors.primary, size: 22.r),
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
