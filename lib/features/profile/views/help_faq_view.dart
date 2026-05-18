import 'package:flutter/material.dart';
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
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(AppStrings.helpFaq, style: AppTextStyles.titleMedium),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: faqs.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, i) {
          final f = faqs[i];
          return Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.grey200),
            ),
            child: ExpansionTile(
              shape: const RoundedRectangleBorder(side: BorderSide(color: Colors.transparent)),
              collapsedShape:
                  const RoundedRectangleBorder(side: BorderSide(color: Colors.transparent)),
              tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
