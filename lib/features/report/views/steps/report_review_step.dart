import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_enums.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../controllers/report_controller.dart';

class ReportReviewStep extends GetView<ReportController> {
  const ReportReviewStep({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Review Report', style: AppTextStyles.headlineSmall),
          const SizedBox(height: 4),
          Text('Please review your report before submitting', style: AppTextStyles.bodySmall),
          const SizedBox(height: 20),

          _section('Problem Details', [
            _row('Category', controller.selectedCategory.value?.label ?? '–'),
            _row('Title', controller.titleController.text),
            _row('Description', controller.descriptionController.text.isEmpty ? '–' : controller.descriptionController.text),
          ]),

          const SizedBox(height: 16),

          _section('Location', [
            _row('Location', controller.locationController.text.isEmpty ? '–' : controller.locationController.text),
            _row('Landmark', controller.landmarkController.text.isEmpty ? '–' : controller.landmarkController.text),
            _row('Contact', controller.contactController.text.isEmpty ? '–' : controller.contactController.text),
          ]),

          const SizedBox(height: 16),

          // Media preview
          Obx(() {
            if (controller.selectedImages.isEmpty) return const SizedBox();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Media (${controller.selectedImages.length})', style: AppTextStyles.titleSmall),
                const SizedBox(height: 8),
                SizedBox(
                  height: 70,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.selectedImages.length,
                    itemBuilder: (_, i) => Container(
                      width: 70, height: 70,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: FileImage(File(controller.selectedImages[i].path)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            );
          }),

          Obx(() => PrimaryButton(
                text: 'Submit Report',
                onPressed: controller.submit,
                isLoading: controller.isSubmitting.value,
                backgroundColor: AppColors.reportOrange,
                icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
              )),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _section(String title, List<Widget> rows) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.titleSmall.copyWith(color: AppColors.reportOrange)),
          const SizedBox(height: 12),
          ...rows,
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: AppTextStyles.caption),
          ),
          Expanded(
            child: Text(value, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
