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

          Text(AppStrings.reportPanchayatLabel, style: AppTextStyles.titleSmall),
          const SizedBox(height: 8),
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

          const SizedBox(height: 14),

          Text(AppStrings.reportWardLabel, style: AppTextStyles.titleSmall),
          const SizedBox(height: 8),
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
