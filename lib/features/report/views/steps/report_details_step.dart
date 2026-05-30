import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_enums.dart';
import '../../../../core/constants/app_strings.dart';
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
          Text(AppStrings.reportDescribeProblem, style: AppTextStyles.headlineSmall),
          const SizedBox(height: 4),
          Text(AppStrings.reportDescribeSubtitle, style: AppTextStyles.bodySmall),
          const SizedBox(height: 20),

          // Category chips
          Text(AppStrings.reportCategoryLabel, style: AppTextStyles.titleSmall),
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

          Obx(() {
            if (controller.selectedCategory.value != ReportCategory.other) {
              return const SizedBox.shrink();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 14),
                Text(AppStrings.reportCategoryLabel, style: AppTextStyles.titleSmall),
                const SizedBox(height: 8),
                TextField(
                  controller: controller.customCategoryController,
                  decoration: InputDecoration(hintText: AppStrings.reportCategoryHint),
                ),
              ],
            );
          }),

          const SizedBox(height: 20),

          // Title
          Text(AppStrings.reportTitleLabel, style: AppTextStyles.titleSmall),
          const SizedBox(height: 8),
          TextField(
            controller: controller.titleController,
            decoration: InputDecoration(hintText: AppStrings.reportCategoryHint),
          ),

          const SizedBox(height: 14),

          // Description — long form + expand
          Row(
            children: [
              Expanded(child: Text(AppStrings.reportDescriptionLabel, style: AppTextStyles.titleSmall)),
              IconButton(
                tooltip: 'Expand editor',
                icon: const Icon(Icons.open_in_full_rounded, size: 22),
                onPressed: () => Get.toNamed(Routes.longFormComposer, arguments: controller.descriptionController),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller.descriptionController,
            minLines: 8,
            maxLines: 16,
            maxLength: 1500,
            decoration: InputDecoration(hintText: AppStrings.reportDescriptionHint),
          ),

          const SizedBox(height: 20),

          // Voice note — separate section
          Text(AppStrings.addVoiceNote, style: AppTextStyles.titleSmall),
          const SizedBox(height: 8),
          VoiceInputWidget(onRecorded: (path) => controller.voiceRecordingPath.value = path),

          const SizedBox(height: 20),

          // Panchayath dropdown — synced with DB by constituency
          Text(AppStrings.reportPanchayatLabel, style: AppTextStyles.titleSmall),
          const SizedBox(height: 8),
          Obx(() {
            if (controller.loadingLocalBodies.value) {
              return const _LoadingField();
            }
            final items = controller.localBodies;
            final selected = controller.selectedLocalBody.value;
            return DropdownButtonFormField<String>(
              key: ValueKey(selected?.id),
              initialValue: selected?.id,
              isExpanded: true,
              decoration: InputDecoration(hintText: AppStrings.selectPanchayat),
              items: items
                  .map((lb) => DropdownMenuItem(
                        value: lb.id,
                        child: Text(lb.name, overflow: TextOverflow.ellipsis),
                      ))
                  .toList(),
              onChanged: (v) {
                final lb = items.firstWhereOrNull((e) => e.id == v);
                if (lb != null) controller.selectLocalBody(lb);
              },
            );
          }),

          const SizedBox(height: 14),

          // Ward dropdown — synced with DB by selected panchayat
          Text(AppStrings.reportWardLabel, style: AppTextStyles.titleSmall),
          const SizedBox(height: 8),
          Obx(() {
            if (controller.loadingWards.value) {
              return const _LoadingField();
            }
            final items = controller.wards;
            final selected = controller.selectedWardModel.value;
            return DropdownButtonFormField<String>(
              key: ValueKey('ward_${controller.selectedLocalBody.value?.id}_${selected?.id}'),
              initialValue: selected?.id,
              isExpanded: true,
              decoration: InputDecoration(hintText: AppStrings.searchWard),
              items: items
                  .map((w) => DropdownMenuItem(
                        value: w.id,
                        child: Text(w.displayName, overflow: TextOverflow.ellipsis),
                      ))
                  .toList(),
              onChanged: items.isEmpty
                  ? null
                  : (v) {
                      final w = items.firstWhereOrNull((e) => e.id == v);
                      if (w != null) controller.selectWardModel(w);
                    },
            );
          }),

          const SizedBox(height: 14),

          // Location description — no GPS icon
          Text(AppStrings.landmark, style: AppTextStyles.titleSmall),
          const SizedBox(height: 8),
          TextField(
            controller: controller.locationController,
            decoration: InputDecoration(hintText: AppStrings.reportDetailsLocationHint),
          ),

          const SizedBox(height: 16),

          // Media upload with 10-file cap
          Obx(
            () => UploadWidget(
              files: controller.selectedImages.toList(),
              maxFiles: 10,
              onChanged: (files) {
                if (files.length > 10) {
                  Get.snackbar(
                    AppStrings.maximumReached,
                    AppStrings.maximumFilesMsg,
                    snackPosition: SnackPosition.BOTTOM,
                  );
                  controller.selectedImages.value = files.take(10).toList();
                  return;
                }
                controller.selectedImages.value = files;
              },
            ),
          ),

          const SizedBox(height: 32),

          PrimaryButton(
            text: AppStrings.reportNextReview,
            onPressed: controller.nextStep,
            backgroundColor: AppColors.reportOrange,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _LoadingField extends StatelessWidget {
  const _LoadingField();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Row(children: [
        const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)),
        const SizedBox(width: 10),
        Text(AppStrings.loading, style: AppTextStyles.caption),
      ]),
    );
  }
}
