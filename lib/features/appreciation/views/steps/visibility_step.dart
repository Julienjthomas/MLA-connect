import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_enums.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../controllers/appreciation_controller.dart';

class AppreciationVisibilityStep extends GetView<AppreciationController> {
  const AppreciationVisibilityStep({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Visibility Option', style: AppTextStyles.headlineSmall),
          const SizedBox(height: 4),
          Text('Choose how you want to share', style: AppTextStyles.bodySmall),
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
                        color: isSelected ? AppColors.appreciateGreenLight : AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: isSelected ? AppColors.appreciateGreen : AppColors.grey200, width: isSelected ? 2 : 1),
                      ),
                      child: Row(children: [
                        Container(
                          width: 20, height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected ? AppColors.appreciateGreen : Colors.transparent,
                            border: Border.all(color: isSelected ? AppColors.appreciateGreen : AppColors.grey400, width: 2),
                          ),
                          child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 12) : null,
                        ),
                        const SizedBox(width: 14),
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(v.label, style: AppTextStyles.titleSmall),
                            Text(v.description, style: AppTextStyles.caption),
                          ],
                        )),
                      ]),
                    ),
                  );
                }).toList(),
              )),
          const SizedBox(height: 16),
          Obx(() => Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.grey200),
                ),
                child: Row(children: [
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Anonymous Submission', style: AppTextStyles.titleSmall),
                    Text('Hide my name and contact details', style: AppTextStyles.caption),
                  ])),
                  Switch.adaptive(
                    value: controller.anonymous.value,
                    onChanged: (v) => controller.anonymous.value = v,
                    activeColor: AppColors.appreciateGreen,
                  ),
                ]),
              )),
          const SizedBox(height: 32),
          PrimaryButton(text: 'Next: Review →', onPressed: controller.nextStep, backgroundColor: AppColors.appreciateGreen),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
