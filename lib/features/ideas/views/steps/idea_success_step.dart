import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_enums.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../controllers/idea_controller.dart';

class IdeaSuccessStep extends StatelessWidget {
  const IdeaSuccessStep({super.key});

  @override
  Widget build(BuildContext context) {
    final visibility = Get.isRegistered<IdeaController>()
        ? Get.find<IdeaController>().visibility.value
        : SubmissionVisibility.public;
    final isPublic = visibility == SubmissionVisibility.public;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.asset('assets/images/app_logo.png', width: 100, height: 100, fit: BoxFit.cover),
            ),
            const SizedBox(height: 24),
            Text(AppStrings.ideaSuccess,
                style: const TextStyle(fontFamily: 'Poppins', fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary, height: 1.3),
                textAlign: TextAlign.center),
            const SizedBox(height: 12),
            Text(AppStrings.ideaSuccessMsg,
                style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            if (isPublic) ...[
              _whatNext(AppStrings.ideaSuccessPublicVisible, Icons.people_outline),
              const SizedBox(height: 10),
              _whatNext(AppStrings.ideaSuccessPublicUpvote, Icons.thumb_up_outlined),
              const SizedBox(height: 10),
            ] else ...[
              _whatNext(AppStrings.ideaSuccessPrivateSent, Icons.lock_outline_rounded),
              const SizedBox(height: 10),
              _whatNext(AppStrings.ideaSuccessPrivateOnly, Icons.visibility_off_outlined),
              const SizedBox(height: 10),
            ],
            _whatNext(AppStrings.ideaSuccessTeamReview, Icons.mark_email_read_outlined),
            const Spacer(),
            PrimaryButton(text: AppStrings.goToMyActivity, onPressed: () => Get.until((r) => r.settings.name == '/home'), backgroundColor: AppColors.ideaPurple),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () { Get.back(); Get.toNamed('/ideas/flow'); },
              child: Text(AppStrings.submitAnotherIdea, style: AppTextStyles.labelMedium.copyWith(color: AppColors.ideaPurple)),
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
