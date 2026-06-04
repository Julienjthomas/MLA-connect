import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/voice_input_widget.dart';
import '../../../../routes/app_routes.dart';
import '../../controllers/improvement_controller.dart';

class SuggestionStep extends GetView<ImprovementController> {
  const SuggestionStep({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.improveHeading, style: AppTextStyles.headlineSmall),
          SizedBox(height: 4.h),
          Text(AppStrings.improveSubtitle, style: AppTextStyles.bodySmall),
          SizedBox(height: 20.h),
          Text(AppStrings.improveDeptLabel, style: AppTextStyles.titleSmall),
          SizedBox(height: 8.h),
          Obx(() => DropdownButtonFormField<String>(
                value: controller.department.value.isEmpty ? null : controller.department.value,
                decoration: InputDecoration(hintText: AppStrings.improveDeptHint),
                items: controller.departments.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                onChanged: (v) => controller.department.value = v ?? '',
              )),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: Text(AppStrings.improveSuggestionLabel, style: AppTextStyles.titleSmall),
              ),
              IconButton(
                tooltip: 'Expand editor',
                icon: Icon(Icons.open_in_full_rounded, size: 22.r),
                onPressed: () =>
                    Get.toNamed(Routes.longFormComposer, arguments: controller.suggestionController),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          TextField(
            controller: controller.suggestionController,
            minLines: 8,
            maxLines: 16,
            maxLength: 1500,
            decoration: InputDecoration(hintText: AppStrings.improveSuggestionHint),
          ),
          SizedBox(height: 20.h),
          Text(AppStrings.addVoiceNote, style: AppTextStyles.titleSmall),
          SizedBox(height: 8.h),
          VoiceInputWidget(onRecorded: (path) => controller.voiceRecordingPath.value = path),
          SizedBox(height: 32.h),
          PrimaryButton(text: AppStrings.improveNextLocation, onPressed: controller.nextStep, backgroundColor: AppColors.improveBlue),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
