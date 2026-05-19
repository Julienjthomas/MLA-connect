import 'package:flutter/material.dart';
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
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.ideaDetailsHeading, style: AppTextStyles.headlineSmall),
          const SizedBox(height: 4),
          Text(AppStrings.ideaDetailsSubtitle, style: AppTextStyles.bodySmall),
          const SizedBox(height: 20),
          Text(AppStrings.ideaTopicLabel, style: AppTextStyles.titleSmall),
          const SizedBox(height: 10),
          Obx(() => Wrap(
                spacing: 8, runSpacing: 8,
                children: controller.topics.map((t) {
                  final isSel = controller.topic.value == t;
                  return GestureDetector(
                    onTap: () => controller.topic.value = t,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSel ? AppColors.ideaPurple : AppColors.grey100,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: isSel ? AppColors.ideaPurple : AppColors.grey300),
                      ),
                      child: Text(t, style: AppTextStyles.labelSmall.copyWith(color: isSel ? Colors.white : AppColors.textSecondary, fontWeight: isSel ? FontWeight.w600 : FontWeight.w400)),
                    ),
                  );
                }).toList(),
              )),
          Obx(() {
            if (controller.topic.value != 'Other') return const SizedBox.shrink();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 14),
                Text(AppStrings.ideaCustomTopicLabel, style: AppTextStyles.titleSmall),
                const SizedBox(height: 8),
                TextField(
                  controller: controller.customTopicController,
                  decoration: InputDecoration(hintText: AppStrings.ideaCustomTopicHint),
                ),
              ],
            );
          }),
          const SizedBox(height: 20),
          Text(AppStrings.ideaTitleLabel, style: AppTextStyles.titleSmall),
          const SizedBox(height: 8),
          TextField(controller: controller.titleController, decoration: InputDecoration(hintText: AppStrings.ideaTitleHint)),
          const SizedBox(height: 14),
          Text(AppStrings.ideaDescLabel, style: AppTextStyles.titleSmall),
          const SizedBox(height: 8),
          Stack(
            children: [
              TextField(
                controller: controller.descriptionController,
                maxLines: 5,
                maxLength: 1000,
                decoration: InputDecoration(
                  hintText: AppStrings.ideaDescHint,
                  contentPadding: const EdgeInsets.fromLTRB(12, 12, 12, 56),
                ),
              ),
              VoiceInputWidget(
                overlayInField: true,
                onTranscript: (t) {
                  final c = controller.descriptionController;
                  final cur = c.text.trim();
                  if (cur.isEmpty) {
                    c.text = t;
                  } else {
                    c.text = '$cur\n$t';
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() => UploadWidget(
                files: controller.selectedImages.toList(),
                maxFiles: 10,
                onChanged: (files) {
                  if (files.length > 10) {
                    Get.snackbar(AppStrings.maximumReached, AppStrings.maximumFilesMsg,
                        snackPosition: SnackPosition.BOTTOM);
                    controller.selectedImages.value = files.take(10).toList();
                    return;
                  }
                  controller.selectedImages.value = files;
                },
              )),
          const SizedBox(height: 32),
          PrimaryButton(text: AppStrings.ideaNextImpact, onPressed: controller.nextStep, backgroundColor: AppColors.ideaPurple),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
