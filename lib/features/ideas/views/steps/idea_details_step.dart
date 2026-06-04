import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/upload_widget.dart';
import '../../../../core/widgets/voice_input_widget.dart';
import '../../controllers/idea_controller.dart';

class IdeaDetailsStep extends GetView<IdeaController> {
  const IdeaDetailsStep({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.ideaDetailsHeading, style: AppTextStyles.headlineSmall),
          SizedBox(height: 4.h),
          Text(AppStrings.ideaDetailsSubtitle, style: AppTextStyles.bodySmall),
          SizedBox(height: 20.h),
          Text(AppStrings.ideaTopicLabel, style: AppTextStyles.titleSmall),
          SizedBox(height: 10.h),
          Obx(
            () => Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: controller.topics.map((t) {
                final isSel = controller.topic.value == t;
                return GestureDetector(
                  onTap: () => controller.topic.value = t,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: isSel ? AppColors.ideaPurple : AppColors.grey100,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: isSel ? AppColors.ideaPurple : AppColors.grey300),
                    ),
                    child: Text(
                      t,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: isSel ? Colors.white : AppColors.textSecondary,
                        fontWeight: isSel ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Obx(() {
            if (controller.topic.value != 'Other') return const SizedBox.shrink();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 14.h),
                Text(AppStrings.ideaCustomTopicLabel, style: AppTextStyles.titleSmall),
                SizedBox(height: 8.h),
                TextField(
                  controller: controller.customTopicController,
                  decoration: InputDecoration(hintText: AppStrings.ideaCustomTopicHint),
                ),
              ],
            );
          }),
          SizedBox(height: 20.h),
          Text(AppStrings.ideaTitleLabel, style: AppTextStyles.titleSmall),
          SizedBox(height: 8.h),
          TextField(
            controller: controller.titleController,
            decoration: InputDecoration(hintText: AppStrings.ideaTitleHint),
          ),
          SizedBox(height: 14.h),
          Text(AppStrings.ideaDescLabel, style: AppTextStyles.titleSmall),
          SizedBox(height: 8.h),
          TextField(
            controller: controller.descriptionController,
            maxLines: 5,
            maxLength: 1000,
            decoration: InputDecoration(
              hintText: AppStrings.ideaDescHint,
              contentPadding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 56.h),
            ),
          ),
          SizedBox(height: 20.h),
          Text(AppStrings.addVoiceNote, style: AppTextStyles.titleSmall),
          SizedBox(height: 8.h),
          VoiceInputWidget(onRecorded: (path) => controller.voiceRecordingPath.value = path),
          SizedBox(height: 16.h),
          Obx(
            () => UploadWidget(
              files: controller.selectedImages.toList(),
              maxFiles: 10,
              onChanged: (files) {
                if (files.length > 10) {
                  Get.snackbar(
                    AppStrings.maximumReached,
                    AppStrings.maximumFilesMsg,
                    snackPosition: SnackPosition.BOTTOM,
                  );
                  controller.selectedImages.value = files.take(10).toList();
                  return;
                }
                controller.selectedImages.value = files;
              },
            ),
          ),
          SizedBox(height: 32.h),
          PrimaryButton(
            text: AppStrings.ideaNextImpact,
            onPressed: controller.nextStep,
            backgroundColor: AppColors.ideaPurple,
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
