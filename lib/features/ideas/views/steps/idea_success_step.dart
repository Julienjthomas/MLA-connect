import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';

class IdeaSuccessStep extends StatelessWidget {
  const IdeaSuccessStep({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Container(
              width: 100, height: 100,
              decoration: const BoxDecoration(color: AppColors.ideaPurple, shape: BoxShape.circle),
              child: const Icon(Icons.rocket_launch_rounded, color: Colors.white, size: 56),
            ),
            const SizedBox(height: 24),
            const Text('Your Idea has been\nSubmitted Successfully!',
                style: TextStyle(fontFamily: 'Poppins', fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary, height: 1.3),
                textAlign: TextAlign.center),
            const SizedBox(height: 12),
            Text('Thank you for contributing to a better constituency. Your idea will be reviewed by our team and you will be notified.',
                style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            _whatNext('Your idea will be visible to the community.', Icons.people_outline),
            const SizedBox(height: 10),
            _whatNext('People can upvote and suggest improvements.', Icons.thumb_up_outlined),
            const SizedBox(height: 10),
            _whatNext('Our team will review and may contact you for more details.', Icons.mark_email_read_outlined),
            const Spacer(),
            PrimaryButton(text: 'Go to My Activity', onPressed: () => Get.until((r) => r.settings.name == '/home'), backgroundColor: AppColors.ideaPurple),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () { Get.back(); Get.toNamed('/ideas/flow'); },
              child: Text('Submit Another Idea', style: AppTextStyles.labelMedium.copyWith(color: AppColors.ideaPurple)),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _whatNext(String text, IconData icon) {
    return Row(children: [
      Icon(icon, size: 18, color: AppColors.ideaPurple),
      const SizedBox(width: 10),
      Expanded(child: Text(text, style: AppTextStyles.bodySmall)),
    ]);
  }
}
