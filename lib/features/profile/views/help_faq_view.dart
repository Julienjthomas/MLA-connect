import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class HelpFaqView extends StatelessWidget {
  const HelpFaqView({super.key});

  static const _faqs = <Map<String, String>>[
    {
      'q': 'What is MLA Connect?',
      'a': 'MLA Connect is your direct line to your MLA and their office. Report issues, share ideas, suggest improvements, and appreciate good work in your constituency — all in one app.'
    },
    {
      'q': 'Who can see my report?',
      'a': 'Reports are shared with the MLA office and the relevant department. You choose the visibility — public (visible to the community), MLA office only, or anonymous.'
    },
    {
      'q': 'How do I track a submission?',
      'a': 'Open the Activity tab in the bottom navigation to see all your submissions and their current status.'
    },
    {
      'q': 'Will I get notified about updates?',
      'a': 'Yes — you will receive in-app notifications when your submission status changes or the MLA office responds.'
    },
    {
      'q': 'Can I edit a submission after sending it?',
      'a': 'Submitted reports cannot be edited, but you can add comments or attach further information from the submission detail screen.'
    },
    {
      'q': 'How do I change my constituency?',
      'a': 'Go to Profile → Edit Profile, or sign out and complete the onboarding flow again with your new constituency.'
    },
    {
      'q': 'Is my personal data private?',
      'a': 'Yes. Your data is stored securely and shared only with the MLA office as required to act on your submission. See the Privacy Policy for full details.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text('Help & FAQ', style: AppTextStyles.titleMedium),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _faqs.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, i) {
          final f = _faqs[i];
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
              title: Text(f['q']!, style: AppTextStyles.titleSmall),
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(f['a']!,
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
