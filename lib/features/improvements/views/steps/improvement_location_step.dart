import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.improveLocationHeading, style: AppTextStyles.headlineSmall),
          SizedBox(height: 4.h),
          Text(AppStrings.improveLocationSubtitle, style: AppTextStyles.bodySmall),
          SizedBox(height: 20.h),

          Text(AppStrings.reportPanchayatLabel, style: AppTextStyles.titleSmall),
          SizedBox(height: 8.h),
          Obx(() {
            if (controller.loadingLocalBodies.value) return const _LoadingField();
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
            if (controller.loadingWards.value) return const _LoadingField();
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
            controller: controller.landmarkController,
            decoration: InputDecoration(hintText: AppStrings.improveLandmarkHint),
          ),

          SizedBox(height: 32.h),
          PrimaryButton(
            text: AppStrings.improveNextReview,
            onPressed: controller.nextStep,
            backgroundColor: AppColors.improveBlue,
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
