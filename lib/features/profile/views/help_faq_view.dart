import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class HelpFaqView extends StatelessWidget {
  const HelpFaqView({super.key});

  @override
  Widget build(BuildContext context) {
    final faqs = AppStrings.helpFaqs;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(AppStrings.helpFaq, style: AppTextStyles.titleMedium),
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(16.r),
        itemCount: faqs.length,
        separatorBuilder: (_, __) => SizedBox(height: 8.h),
        itemBuilder: (_, i) {
          final f = faqs[i];
          return Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.grey200),
            ),
            child: ExpansionTile(
              shape: const RoundedRectangleBorder(side: BorderSide(color: Colors.transparent)),
              collapsedShape:
                  const RoundedRectangleBorder(side: BorderSide(color: Colors.transparent)),
              tilePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
              childrenPadding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
              title: Text(f.question, style: AppTextStyles.titleSmall),
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(f.answer,
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
