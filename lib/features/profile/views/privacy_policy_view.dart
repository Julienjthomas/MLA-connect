import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({super.key});

  static const _lastUpdated = 'Last updated: May 2026';

  static const _sections = <Map<String, String>>[
    {
      'h': '1. Introduction',
      'b': 'MLA Connect ("we", "us") is a civic engagement platform. This Privacy Policy describes how we collect, use, and protect your information when you use this app.'
    },
    {
      'h': '2. Information we collect',
      'b': 'Account information (phone number, name, photo, constituency), submission content (text, images, voice messages, location), and basic device telemetry needed to operate the service.'
    },
    {
      'h': '3. How we use your information',
      'b': 'To route your submissions to the appropriate MLA office and departments, to provide status updates, to display public submissions to the community where you have chosen public visibility, and to improve the service.'
    },
    {
      'h': '4. Sharing',
      'b': 'We share submission content with the MLA office and the relevant department. Public submissions are visible to other citizens within your constituency. We do not sell your personal data to third parties.'
    },
    {
      'h': '5. Storage and security',
      'b': 'Data is stored on secure infrastructure with industry-standard access controls. Voice and image attachments are stored in private buckets and accessed via signed URLs.'
    },
    {
      'h': '6. Your choices',
      'b': 'You can choose the visibility of each submission (public, MLA office only, anonymous). You can request deletion of your account and associated data by contacting the MLA office through the app.'
    },
    {
      'h': '7. Contact',
      'b': 'For privacy questions, use the Contact MLA Office screen in this app.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text('Privacy Policy', style: AppTextStyles.titleMedium),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ..._sections.expand((s) => [
                Text(s['h']!, style: AppTextStyles.titleSmall),
                const SizedBox(height: 4),
                Text(s['b']!,
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: 16),
              ]),
          const SizedBox(height: 8),
          Text(_lastUpdated,
              style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary)),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
