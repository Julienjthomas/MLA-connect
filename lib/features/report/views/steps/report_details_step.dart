import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_enums.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/upload_widget.dart';
import '../../controllers/report_controller.dart';

class ReportDetailsStep extends GetView<ReportController> {
  const ReportDetailsStep({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Describe the Problem', style: AppTextStyles.headlineSmall),
          const SizedBox(height: 4),
          const Text('Please provide details about the issue', style: AppTextStyles.bodySmall),
          const SizedBox(height: 20),

          // Category selection
          const Text('Category *', style: AppTextStyles.titleSmall),
          const SizedBox(height: 10),
          Obx(
            () => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ReportCategory.values.map((cat) {
                final isSelected = controller.selectedCategory.value == cat;
                return GestureDetector(
                  onTap: () => controller.selectedCategory.value = cat,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.reportOrange : AppColors.grey100,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: isSelected ? AppColors.reportOrange : AppColors.grey300),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(cat.icon, size: 14, color: isSelected ? Colors.white : AppColors.grey600),
                        const SizedBox(width: 6),
                        Text(
                          cat.label,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: isSelected ? Colors.white : AppColors.textSecondary,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 20),

          // Problem description
          const Text('Problem Description *', style: AppTextStyles.titleSmall),
          const SizedBox(height: 8),
          TextField(
            controller: controller.titleController,
            decoration: const InputDecoration(hintText: 'Brief title of the problem'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: controller.descriptionController,
            maxLines: 4,
            maxLength: 500,
            decoration: const InputDecoration(hintText: 'Describe the problem in detail...'),
          ),

          const SizedBox(height: 16),

          // Voice note placeholder
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.grey300),
            ),
            child: const Row(
              children: [
                Icon(Icons.mic_outlined, color: AppColors.grey500),
                SizedBox(width: 10),
                Text('Add Voice Message', style: AppTextStyles.bodySmall),
                Spacer(),
                Text('Optional', style: AppTextStyles.caption),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Media upload
          Obx(
            () => UploadWidget(
              files: controller.selectedImages.value,
              onChanged: (files) => controller.selectedImages.value = files,
            ),
          ),

          const SizedBox(height: 32),

          PrimaryButton(
            text: 'Next: Location →',
            onPressed: controller.nextStep,
            backgroundColor: AppColors.reportOrange,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
