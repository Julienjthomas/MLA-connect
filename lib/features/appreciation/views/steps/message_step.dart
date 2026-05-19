import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/upload_widget.dart';
import '../../controllers/appreciation_controller.dart';

class MessageStep extends GetView<AppreciationController> {
  const MessageStep({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.appreciateMessageHeading, style: AppTextStyles.headlineSmall),
          const SizedBox(height: 4),
          Text(AppStrings.appreciateMessageSubtitle, style: AppTextStyles.bodySmall),
          const SizedBox(height: 20),
          TextField(
            controller: controller.messageController,
            maxLines: 6,
            maxLength: 500,
            decoration: InputDecoration(hintText: AppStrings.appreciateMessageHint),
          ),
          const SizedBox(height: 16),
          Obx(
            () => UploadWidget(
              files: controller.selectedImages.toList(),
              onChanged: (files) {
                controller.selectedImages.value = files;
              },
              label: AppStrings.appreciateAddPhotoLabel,
            ),
          ),
          const SizedBox(height: 32),
          PrimaryButton(
            text: AppStrings.appreciateNextVisibility,
            onPressed: controller.nextStep,
            backgroundColor: AppColors.appreciateGreen,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
