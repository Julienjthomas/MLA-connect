import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/upload_widget.dart';
import '../../../../core/widgets/voice_input_widget.dart';
import '../../controllers/appreciation_controller.dart';

class MessageStep extends GetView<AppreciationController> {
  const MessageStep({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.appreciateMessageHeading, style: AppTextStyles.headlineSmall),
          SizedBox(height: 4.h),
          Text(AppStrings.appreciateMessageSubtitle, style: AppTextStyles.bodySmall),
          SizedBox(height: 20.h),
          TextField(
            controller: controller.messageController,
            maxLines: 6,
            maxLength: 500,
            decoration: InputDecoration(hintText: AppStrings.appreciateMessageHint),
          ),
          SizedBox(height: 20.h),
          Text(AppStrings.addVoiceNote, style: AppTextStyles.titleSmall),
          SizedBox(height: 8.h),
          VoiceInputWidget(onRecorded: (path) => controller.voiceRecordingPath.value = path),
          SizedBox(height: 16.h),
          Obx(
            () => UploadWidget(
              files: controller.selectedImages.toList(),
              onChanged: (files) {
                controller.selectedImages.value = files;
              },
              label: AppStrings.appreciateAddPhotoLabel,
            ),
          ),
          SizedBox(height: 32.h),
          PrimaryButton(
            text: AppStrings.appreciateNextVisibility,
            onPressed: controller.nextStep,
            backgroundColor: AppColors.appreciateGreen,
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
