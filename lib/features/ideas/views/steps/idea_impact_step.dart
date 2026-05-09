import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../controllers/idea_controller.dart';

class IdeaImpactStep extends GetView<IdeaController> {
  const IdeaImpactStep({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Key Benefits & Expected Impact', style: AppTextStyles.headlineSmall),
          const SizedBox(height: 4),
          Text('Help us understand the potential impact', style: AppTextStyles.bodySmall),
          const SizedBox(height: 20),
          Text('List 2–3 major advantages for the constituency *', style: AppTextStyles.titleSmall),
          const SizedBox(height: 8),
          TextField(controller: controller.benefitsController, maxLines: 4, maxLength: 500,
              decoration: const InputDecoration(hintText: '• Reduces flooding in low-lying areas\n• Protects public health...')),
          const SizedBox(height: 16),
          Text('Who will benefit from this idea? *', style: AppTextStyles.titleSmall),
          const SizedBox(height: 10),
          Obx(() => Wrap(
                spacing: 8, runSpacing: 8,
                children: controller.allBeneficiaries.map((b) {
                  final isSel = controller.beneficiaries.contains(b);
                  return GestureDetector(
                    onTap: () => controller.toggleBeneficiary(b),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSel ? AppColors.ideaPurpleLight : AppColors.grey100,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: isSel ? AppColors.ideaPurple : AppColors.grey300),
                      ),
                      child: Text(b, style: AppTextStyles.labelSmall.copyWith(color: isSel ? AppColors.ideaPurple : AppColors.textSecondary)),
                    ),
                  );
                }).toList(),
              )),
          const SizedBox(height: 16),
          Text('Estimated Resources (Optional)', style: AppTextStyles.titleSmall),
          const SizedBox(height: 8),
          Obx(() => DropdownButtonFormField<String>(
                value: controller.estimatedResources.value.isEmpty ? null : controller.estimatedResources.value,
                decoration: const InputDecoration(hintText: 'Select Range'),
                items: controller.resourceRanges.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                onChanged: (v) => controller.estimatedResources.value = v ?? '',
              )),
          const SizedBox(height: 32),
          PrimaryButton(text: 'Next: Visibility →', onPressed: controller.nextStep, backgroundColor: AppColors.ideaPurple),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
