import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
          const Text('Your Appreciation', style: AppTextStyles.headlineSmall),
          const SizedBox(height: 4),
          const Text('Write your appreciation message', style: AppTextStyles.bodySmall),
          const SizedBox(height: 20),
          TextField(
            controller: controller.messageController,
            maxLines: 6,
            maxLength: 500,
            decoration: const InputDecoration(hintText: 'I appreciate the quick action taken by the team...'),
          ),
          const SizedBox(height: 16),
          Obx(
            () => UploadWidget(
              files: controller.selectedImages,
              onChanged: (files) {
                controller.selectedImages.clear();
                controller.selectedImages.addAll(files);
              },
              label: 'Add Photo / Video (Optional)',
            ),
          ),
          const SizedBox(height: 32),
          PrimaryButton(
            text: 'Next: Visibility →',
            onPressed: controller.nextStep,
            backgroundColor: AppColors.appreciateGreen,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
