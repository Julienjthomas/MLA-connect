import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
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
          Text('Idea Details', style: AppTextStyles.headlineSmall),
          const SizedBox(height: 4),
          Text('Tell us about your idea', style: AppTextStyles.bodySmall),
          const SizedBox(height: 20),
          Text('What is your idea about? (Topic) *', style: AppTextStyles.titleSmall),
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
                Text('Custom Topic *', style: AppTextStyles.titleSmall),
                const SizedBox(height: 8),
                TextField(
                  controller: controller.customTopicController,
                  decoration: const InputDecoration(hintText: 'Enter your topic'),
                ),
              ],
            );
          }),
          const SizedBox(height: 20),
          Text('Idea Title *', style: AppTextStyles.titleSmall),
          const SizedBox(height: 8),
          TextField(controller: controller.titleController, decoration: const InputDecoration(hintText: 'e.g. Smart Drainage System for Balussery')),
          const SizedBox(height: 14),
          Text('Describe your idea in detail', style: AppTextStyles.titleSmall),
          const SizedBox(height: 8),
          TextField(controller: controller.descriptionController, maxLines: 5, maxLength: 1000, decoration: const InputDecoration(hintText: 'My idea is to build a smart drainage system...')),
          const SizedBox(height: 32),
          PrimaryButton(text: 'Next: Impact & Benefits →', onPressed: controller.nextStep, backgroundColor: AppColors.ideaPurple),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
