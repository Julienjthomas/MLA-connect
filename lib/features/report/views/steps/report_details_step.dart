import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_enums.dart';
import '../../../../core/constants/geo_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/upload_widget.dart';
import '../../../../core/widgets/voice_input_widget.dart';
import '../../../../routes/app_routes.dart';
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

          // Category chips
          const Text('Category *', style: AppTextStyles.titleSmall),
          const SizedBox(height: 10),
          Obx(() => Wrap(
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
                        border: Border.all(
                            color: isSelected ? AppColors.reportOrange : AppColors.grey300),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(cat.icon,
                              size: 14, color: isSelected ? Colors.white : AppColors.grey600),
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
              )),

          Obx(() {
            if (controller.selectedCategory.value != ReportCategory.other) {
              return const SizedBox.shrink();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 14),
                const Text('Custom Category *', style: AppTextStyles.titleSmall),
                const SizedBox(height: 8),
                TextField(
                  controller: controller.customCategoryController,
                  decoration: const InputDecoration(
                    hintText: 'Enter the problem category',
                  ),
                ),
              ],
            );
          }),

          const SizedBox(height: 20),

          // Title
          const Text('Problem Title *', style: AppTextStyles.titleSmall),
          const SizedBox(height: 8),
          TextField(
            controller: controller.titleController,
            decoration: const InputDecoration(hintText: 'Brief title of the problem'),
          ),

          const SizedBox(height: 14),

          // Description — long form + expand + voice (mic on right)
          Row(
            children: [
              const Expanded(
                child: Text('Problem Description *', style: AppTextStyles.titleSmall),
              ),
              IconButton(
                tooltip: 'Expand editor',
                icon: const Icon(Icons.open_in_full_rounded, size: 22),
                onPressed: () =>
                    Get.toNamed(Routes.longFormComposer, arguments: controller.descriptionController),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Stack(
            children: [
              TextField(
                controller: controller.descriptionController,
                minLines: 8,
                maxLines: 16,
                maxLength: 1500,
                decoration: const InputDecoration(
                  hintText: 'Describe the problem in detail...',
                  contentPadding: EdgeInsets.fromLTRB(12, 12, 12, 56),
                ),
              ),
              VoiceInputWidget(
                overlayInField: true,
                onTranscript: (t) {
                  final c = controller.descriptionController;
                  final cur = c.text.trim();
                  if (cur.isEmpty) {
                    c.text = t;
                  } else {
                    c.text = '$cur\n$t';
                  }
                },
                onRecorded: (path) => controller.voiceRecordingPath.value = path,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Panchayath dropdown
          const Text('Panchayath *', style: AppTextStyles.titleSmall),
          const SizedBox(height: 8),
          Obx(() {
            final panchayath = controller.selectedPanchayath.value;
            return DropdownButtonFormField<String>(
              key: ValueKey(panchayath),
              value: panchayath.isEmpty ? null : panchayath,
              decoration: const InputDecoration(hintText: 'Select Panchayath'),
              items: GeoConstants.panchayaths
                  .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                  .toList(),
              onChanged: (v) {
                controller.selectedPanchayath.value = v ?? '';
                controller.selectedWard.value = '';
              },
            );
          }),

          const SizedBox(height: 14),

          // Ward dropdown
          const Text('Ward *', style: AppTextStyles.titleSmall),
          const SizedBox(height: 8),
          Obx(() {
            final panchayath = controller.selectedPanchayath.value;
            final ward = controller.selectedWard.value;
            final wards = GeoConstants.wardsFor(panchayath.isEmpty ? null : panchayath);
            return DropdownButtonFormField<String>(
              key: ValueKey('ward_$panchayath'),
              value: ward.isEmpty ? null : ward,
              decoration: const InputDecoration(hintText: 'Select Ward'),
              items: wards.map((w) => DropdownMenuItem(value: w, child: Text(w))).toList(),
              onChanged: wards.isEmpty ? null : (v) => controller.selectedWard.value = v ?? '',
            );
          }),

          const SizedBox(height: 14),

          // Location description — no GPS icon
          const Text('Location Description', style: AppTextStyles.titleSmall),
          const SizedBox(height: 8),
          TextField(
            controller: controller.locationController,
            decoration: const InputDecoration(
              hintText: 'Describe the exact location of the problem',
            ),
          ),

          const SizedBox(height: 16),

          // Media upload with 10-file cap
          Obx(() => UploadWidget(
                files: controller.selectedImages.toList(),
                maxFiles: 10,
                onChanged: (files) {
                  if (files.length > 10) {
                    Get.snackbar('Maximum reached', 'Maximum 10 files allowed',
                        snackPosition: SnackPosition.BOTTOM);
                    controller.selectedImages.value = files.take(10).toList();
                    return;
                  }
                  controller.selectedImages.value = files;
                },
              )),

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
