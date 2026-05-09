import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../controllers/improvement_controller.dart';

class SuggestionStep extends GetView<ImprovementController> {
  const SuggestionStep({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Suggestion Details', style: AppTextStyles.headlineSmall),
          const SizedBox(height: 4),
          Text('Share your improvement suggestion', style: AppTextStyles.bodySmall),
          const SizedBox(height: 20),
          Text('Target Department (Optional)', style: AppTextStyles.titleSmall),
          const SizedBox(height: 8),
          Obx(() => DropdownButtonFormField<String>(
                value: controller.department.value.isEmpty ? null : controller.department.value,
                decoration: const InputDecoration(hintText: 'Select Department'),
                items: controller.departments.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                onChanged: (v) => controller.department.value = v ?? '',
              )),
          const SizedBox(height: 14),
          Text('Your Suggestion *', style: AppTextStyles.titleSmall),
          const SizedBox(height: 8),
          TextField(
            controller: controller.suggestionController,
            maxLines: 6, maxLength: 600,
            decoration: const InputDecoration(hintText: 'Describe your improvement suggestion in detail...'),
          ),
          const SizedBox(height: 32),
          PrimaryButton(text: 'Next: Location →', onPressed: controller.nextStep, backgroundColor: AppColors.improveBlue),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
