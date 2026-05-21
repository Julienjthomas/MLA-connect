import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/geo_constants.dart';
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

          Text(AppStrings.reportPanchayatLabel, style: AppTextStyles.titleSmall),
          const SizedBox(height: 8),
          Obx(() {
            final panchayath = controller.selectedPanchayath.value;
            return DropdownButtonFormField<String>(
              key: ValueKey(panchayath),
              value: panchayath.isEmpty ? null : panchayath,
              decoration: InputDecoration(hintText: AppStrings.selectPanchayat),
              items: GeoConstants.panchayaths.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
              onChanged: (v) {
                controller.selectedPanchayath.value = v ?? '';
                controller.selectedWard.value = '';
              },
            );
          }),

          const SizedBox(height: 14),

          Text(AppStrings.reportWardLabel, style: AppTextStyles.titleSmall),
          const SizedBox(height: 8),
          Obx(() {
            final panchayath = controller.selectedPanchayath.value;
            final ward = controller.selectedWard.value;
            final wards = GeoConstants.wardsFor(panchayath.isEmpty ? null : panchayath);
            return DropdownButtonFormField<String>(
              key: ValueKey('ward_$panchayath'),
              value: ward.isEmpty ? null : ward,
              decoration: InputDecoration(hintText: AppStrings.searchWard),
              items: wards.map((w) => DropdownMenuItem(value: w, child: Text(w))).toList(),
              onChanged: wards.isEmpty ? null : (v) => controller.selectedWard.value = v ?? '',
            );
          }),

          const SizedBox(height: 14),

          Text(AppStrings.landmark, style: AppTextStyles.titleSmall),
          const SizedBox(height: 8),
          TextField(
            controller: controller.landmarkController,
            decoration: InputDecoration(hintText: AppStrings.improveLandmarkHint),
          ),

          const SizedBox(height: 32),
          PrimaryButton(
            text: AppStrings.improveNextReview,
            onPressed: controller.nextStep,
            backgroundColor: AppColors.improveBlue,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
