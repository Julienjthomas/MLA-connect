import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.reportDescribeProblem, style: AppTextStyles.headlineSmall),
          SizedBox(height: 4.h),
          Text(AppStrings.reportDescribeSubtitle, style: AppTextStyles.bodySmall),
          SizedBox(height: 20.h),

          Text(AppStrings.reportCategoryLabel, style: AppTextStyles.titleSmall),
          SizedBox(height: 10.h),
          Obx(
            () => Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: ReportCategory.values.map((cat) {
                final isSelected = controller.selectedCategory.value == cat;
                return GestureDetector(
                  onTap: () => controller.selectedCategory.value = cat,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.reportOrange : AppColors.grey100,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: isSelected ? AppColors.reportOrange : AppColors.grey300),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(cat.icon, size: 14.r, color: isSelected ? Colors.white : AppColors.grey600),
                        SizedBox(width: 6.w),
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
                SizedBox(height: 14.h),
                Text(AppStrings.reportCategoryLabel, style: AppTextStyles.titleSmall),
                SizedBox(height: 8.h),
                TextField(
                  controller: controller.customCategoryController,
                  decoration: InputDecoration(hintText: AppStrings.reportCategoryHint),
                ),
              ],
            );
          }),

          SizedBox(height: 20.h),

          Text(AppStrings.reportTitleLabel, style: AppTextStyles.titleSmall),
          SizedBox(height: 8.h),
          TextField(
            controller: controller.titleController,
            decoration: InputDecoration(hintText: AppStrings.reportCategoryHint),
          ),

          SizedBox(height: 14.h),

          Row(
            children: [
              Expanded(child: Text(AppStrings.reportDescriptionLabel, style: AppTextStyles.titleSmall)),
              IconButton(
                tooltip: 'Expand editor',
                icon: Icon(Icons.open_in_full_rounded, size: 22.r),
                onPressed: () => Get.toNamed(Routes.longFormComposer, arguments: controller.descriptionController),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          TextField(
            controller: controller.descriptionController,
            minLines: 8,
            maxLines: 16,
            maxLength: 1500,
            decoration: InputDecoration(hintText: AppStrings.reportDescriptionHint),
          ),

          SizedBox(height: 20.h),

          Text(AppStrings.addVoiceNote, style: AppTextStyles.titleSmall),
          SizedBox(height: 8.h),
          VoiceInputWidget(onRecorded: (path) => controller.voiceRecordingPath.value = path),

          SizedBox(height: 20.h),

          Text(AppStrings.reportPanchayatLabel, style: AppTextStyles.titleSmall),
          SizedBox(height: 8.h),
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

          SizedBox(height: 14.h),

          Text(AppStrings.reportWardLabel, style: AppTextStyles.titleSmall),
          SizedBox(height: 8.h),
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

          SizedBox(height: 14.h),

          Text(AppStrings.landmark, style: AppTextStyles.titleSmall),
          SizedBox(height: 8.h),
          TextField(
            controller: controller.locationController,
            decoration: InputDecoration(hintText: AppStrings.reportDetailsLocationHint),
          ),

          SizedBox(height: 16.h),

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

          SizedBox(height: 32.h),

          PrimaryButton(
            text: AppStrings.reportNextReview,
            onPressed: controller.nextStep,
            backgroundColor: AppColors.reportOrange,
          ),
          SizedBox(height: 20.h),
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
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Row(children: [
        SizedBox(width: 18.r, height: 18.r, child: const CircularProgressIndicator(strokeWidth: 2)),
        SizedBox(width: 10.w),
        Text(AppStrings.loading, style: AppTextStyles.caption),
      ]),
    );
  }
}
