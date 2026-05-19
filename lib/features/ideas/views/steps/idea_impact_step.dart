import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_strings.dart';
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
          Text(AppStrings.ideaImpactHeading, style: AppTextStyles.headlineSmall),
          const SizedBox(height: 4),
          Text(AppStrings.ideaImpactSubtitle, style: AppTextStyles.bodySmall),
          const SizedBox(height: 20),
          Text(AppStrings.ideaBenefitsLabel, style: AppTextStyles.titleSmall),
          const SizedBox(height: 8),
          TextField(controller: controller.benefitsController, maxLines: 4, maxLength: 500,
              decoration: InputDecoration(hintText: AppStrings.ideaBenefitsHint)),
          const SizedBox(height: 16),
          Text(AppStrings.ideaBeneficiariesLabel, style: AppTextStyles.titleSmall),
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
          Text(AppStrings.ideaResourcesLabel, style: AppTextStyles.titleSmall),
          const SizedBox(height: 8),
          Obx(() => DropdownButtonFormField<String>(
                value: controller.estimatedResources.value.isEmpty ? null : controller.estimatedResources.value,
                decoration: InputDecoration(hintText: AppStrings.ideaResourcesHint),
                items: controller.resourceRanges.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                onChanged: (v) => controller.estimatedResources.value = v ?? '',
              )),
          const SizedBox(height: 32),
          PrimaryButton(text: AppStrings.ideaNextVisibility, onPressed: controller.nextStep, backgroundColor: AppColors.ideaPurple),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
