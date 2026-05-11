import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../controllers/report_controller.dart';

class ReportLocationStep extends GetView<ReportController> {
  const ReportLocationStep({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Location', style: AppTextStyles.headlineSmall),
          const SizedBox(height: 4),
          Text('Help us find the exact location of the issue', style: AppTextStyles.bodySmall),
          const SizedBox(height: 20),

          // Panchayat (read-only from user profile for now)
          Text('Panchayat', style: AppTextStyles.titleSmall),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.grey200),
            ),
            child: Row(children: [
              const Icon(Icons.location_city_outlined, size: 18, color: AppColors.grey500),
              const SizedBox(width: 10),
              Text('Balussery Panchayat', style: AppTextStyles.bodyMedium),
            ]),
          ),

          const SizedBox(height: 14),

          // Ward
          Text('Ward *', style: AppTextStyles.titleSmall),
          const SizedBox(height: 8),
          TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.map_outlined, size: 20),
              hintText: 'e.g. Ward 12 – Kuttikattoor',
            ),
          ),

          const SizedBox(height: 14),

          // Landmark
          Text('Landmark / Area (Optional)', style: AppTextStyles.titleSmall),
          const SizedBox(height: 8),
          TextField(
            controller: controller.landmarkController,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.place_outlined, size: 20),
              hintText: 'e.g. Near Kuttikattoor Juma Masjid',
            ),
          ),

          const SizedBox(height: 14),

          // Location description
          Text('Location Description *', style: AppTextStyles.titleSmall),
          const SizedBox(height: 8),
          TextField(
            controller: controller.locationController,
            decoration: const InputDecoration(
              hintText: 'Describe the location',
            ),
          ),

          const SizedBox(height: 6),
          Row(children: [
            const Icon(Icons.info_outline, size: 13, color: AppColors.textTertiary),
            const SizedBox(width: 4),
            Text('Tap the location icon to use GPS', style: AppTextStyles.caption),
          ]),

          const SizedBox(height: 14),

          // Map placeholder
          Container(
            height: 140,
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.grey200),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.map_outlined, size: 40, color: AppColors.grey400),
                  const SizedBox(height: 8),
                  Text('Tap to pin on map', style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey500)),
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Contact number
          Text('Contact Number (Optional)', style: AppTextStyles.titleSmall),
          const SizedBox(height: 8),
          TextField(
            controller: controller.contactController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.phone_outlined, size: 20),
              hintText: '+91 90 47 123 456',
            ),
          ),

          const SizedBox(height: 32),

          PrimaryButton(
            text: 'Next: Review →',
            onPressed: controller.nextStep,
            backgroundColor: AppColors.reportOrange,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
