import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../controllers/appreciation_controller.dart';

class RecipientStep extends GetView<AppreciationController> {
  const RecipientStep({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Who are you appreciating?', style: AppTextStyles.headlineSmall),
          const SizedBox(height: 20),
          Text('Recipient Category *', style: AppTextStyles.titleSmall),
          const SizedBox(height: 10),
          Obx(() => Column(
                children: controller.recipientCategories.map((cat) {
                  final isSelected = controller.recipientCategory.value == cat;
                  return GestureDetector(
                    onTap: () => controller.recipientCategory.value = cat,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.appreciateGreenLight : AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
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
                        const SizedBox(width: 12),
                        Text(cat, style: AppTextStyles.titleSmall),
                      ]),
                    ),
                  );
                }).toList(),
              )),
          const SizedBox(height: 14),
          Text('Staff Name / ID (Optional)', style: AppTextStyles.titleSmall),
          const SizedBox(height: 8),
          TextField(controller: controller.staffController, decoration: const InputDecoration(hintText: 'e.g. Ajith Kumar, AE')),
          const SizedBox(height: 14),
          Text('Related Work / Project (Optional)', style: AppTextStyles.titleSmall),
          const SizedBox(height: 8),
          TextField(controller: controller.relatedWorkController, decoration: const InputDecoration(hintText: 'e.g. Road repair at Kuttikattoor')),
          const SizedBox(height: 32),
          PrimaryButton(text: 'Next: Your Message →', onPressed: controller.nextStep, backgroundColor: AppColors.appreciateGreen),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
