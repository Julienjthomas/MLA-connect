import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../controllers/improvement_controller.dart';

class ImprovementLocationStep extends GetView<ImprovementController> {
  const ImprovementLocationStep({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Location (Optional)', style: AppTextStyles.headlineSmall),
          const SizedBox(height: 4),
          Text('Where should this improvement be made?', style: AppTextStyles.bodySmall),
          const SizedBox(height: 20),
          Text('Location / Area', style: AppTextStyles.titleSmall),
          const SizedBox(height: 8),
          TextField(
            controller: controller.locationController,
            decoration: const InputDecoration(
              hintText: 'e.g. Near the main market',
            ),
          ),
          const SizedBox(height: 14),
          Text('Landmark (Optional)', style: AppTextStyles.titleSmall),
          const SizedBox(height: 8),
          TextField(
            controller: controller.landmarkController,
            decoration: const InputDecoration(prefixIcon: Icon(Icons.place_outlined, size: 20), hintText: 'Nearby landmark'),
          ),
          const SizedBox(height: 32),
          PrimaryButton(text: 'Next: Review →', onPressed: controller.nextStep, backgroundColor: AppColors.improveBlue),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
