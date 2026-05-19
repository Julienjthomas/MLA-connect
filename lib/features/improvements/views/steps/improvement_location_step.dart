import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_strings.dart';
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
          Text(AppStrings.improveLocationHeading, style: AppTextStyles.headlineSmall),
          const SizedBox(height: 4),
          Text(AppStrings.improveLocationSubtitle, style: AppTextStyles.bodySmall),
          const SizedBox(height: 20),
          Text(AppStrings.improveLocationLabel, style: AppTextStyles.titleSmall),
          const SizedBox(height: 8),
          TextField(
            controller: controller.locationController,
            decoration: InputDecoration(
              hintText: AppStrings.improveLocationHint,
            ),
          ),
          const SizedBox(height: 14),
          Text(AppStrings.improveLandmarkLabel, style: AppTextStyles.titleSmall),
          const SizedBox(height: 8),
          TextField(
            controller: controller.landmarkController,
            decoration: InputDecoration(prefixIcon: const Icon(Icons.place_outlined, size: 20), hintText: AppStrings.improveLandmarkHint),
          ),
          const SizedBox(height: 32),
          PrimaryButton(text: AppStrings.improveNextReview, onPressed: controller.nextStep, backgroundColor: AppColors.improveBlue),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
