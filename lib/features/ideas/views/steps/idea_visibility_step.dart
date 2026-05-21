import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_enums.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../controllers/idea_controller.dart';

class IdeaVisibilityStep extends GetView<IdeaController> {
  const IdeaVisibilityStep({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.ideaVisibilityHeading, style: AppTextStyles.headlineSmall),
          const SizedBox(height: 4),
          Text(AppStrings.ideaVisibilitySubtitle, style: AppTextStyles.bodySmall),
          const SizedBox(height: 24),
          Obx(() => Column(
                children: SubmissionVisibility.values.map((v) {
                  final isSelected = controller.visibility.value == v;
                  return GestureDetector(
                    onTap: () => controller.visibility.value = v,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.ideaPurpleLight : AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: isSelected ? AppColors.ideaPurple : AppColors.grey200, width: isSelected ? 2 : 1),
                      ),
                      child: Row(children: [
                        Container(
                          width: 20, height: 20,
                          decoration: BoxDecoration(shape: BoxShape.circle,
                              color: isSelected ? AppColors.ideaPurple : Colors.transparent,
                              border: Border.all(color: isSelected ? AppColors.ideaPurple : AppColors.grey400, width: 2)),
                          child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 12) : null,
                        ),
                        const SizedBox(width: 14),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(v.label, style: AppTextStyles.titleSmall),
                          Text(v.description, style: AppTextStyles.caption),
                        ])),
                      ]),
                    ),
                  );
                }).toList(),
              )),
          const SizedBox(height: 16),
          Obx(() => _toggle(AppStrings.ideaDiscussionLabel, AppStrings.ideaDiscussionSubtitle,
              controller.allowDiscussion.value, (v) => controller.allowDiscussion.value = v)),
          const SizedBox(height: 12),
          Obx(() => _toggle(AppStrings.ideaContactLabel, AppStrings.ideaContactSubtitle,
              controller.allowContact.value, (v) => controller.allowContact.value = v)),
          const SizedBox(height: 32),
          PrimaryButton(text: AppStrings.ideaNextReview, onPressed: controller.nextStep, backgroundColor: AppColors.ideaPurple),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _toggle(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.grey200)),
      child: Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: AppTextStyles.titleSmall),
          Text(subtitle, style: AppTextStyles.caption),
        ])),
        Switch.adaptive(value: value, onChanged: onChanged, activeThumbColor: AppColors.ideaPurple),
      ]),
    );
  }
}
