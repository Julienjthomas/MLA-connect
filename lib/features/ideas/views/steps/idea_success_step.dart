import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Container(
              width: 100.r,
              height: 100.r,
              decoration: const BoxDecoration(color: AppColors.ideaPurple, shape: BoxShape.circle),
              child: Icon(Icons.check_rounded, color: Colors.white, size: 60.r),
            ),
            SizedBox(height: 24.h),
            Text(AppStrings.ideaSuccess,
                style: TextStyle(fontFamily: 'Poppins', fontSize: 22.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary, height: 1.3),
                textAlign: TextAlign.center),
            SizedBox(height: 12.h),
            Text(AppStrings.ideaSuccessMsg,
                style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
            SizedBox(height: 24.h),
            if (isPublic) ...[
              _whatNext(AppStrings.ideaSuccessPublicVisible, Icons.people_outline),
              SizedBox(height: 10.h),
              _whatNext(AppStrings.ideaSuccessPublicUpvote, Icons.thumb_up_outlined),
              SizedBox(height: 10.h),
            ] else ...[
              _whatNext(AppStrings.ideaSuccessPrivateSent, Icons.lock_outline_rounded),
              SizedBox(height: 10.h),
              _whatNext(AppStrings.ideaSuccessPrivateOnly, Icons.visibility_off_outlined),
              SizedBox(height: 10.h),
            ],
            _whatNext(AppStrings.ideaSuccessTeamReview, Icons.mark_email_read_outlined),
            const Spacer(),
            PrimaryButton(text: AppStrings.goToMyActivity, onPressed: () => Get.until((r) => r.settings.name == '/home'), backgroundColor: AppColors.ideaPurple),
            SizedBox(height: 12.h),
            SecondaryButton(
              text: AppStrings.submitAnotherIdea,
              onPressed: () { Get.back(); Get.toNamed('/ideas/flow'); },
              color: AppColors.ideaPurple,
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }

  Widget _whatNext(String text, IconData icon) {
    return Row(children: [
      Icon(icon, size: 18.r, color: AppColors.ideaPurple),
      SizedBox(width: 10.w),
      Expanded(child: Text(text, style: AppTextStyles.bodySmall)),
    ]);
  }
}
