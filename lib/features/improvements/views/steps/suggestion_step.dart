import 'package:flutter/material.dart';
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
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.improveHeading, style: AppTextStyles.headlineSmall),
          const SizedBox(height: 4),
          Text(AppStrings.improveSubtitle, style: AppTextStyles.bodySmall),
          const SizedBox(height: 20),
          Text(AppStrings.improveDeptLabel, style: AppTextStyles.titleSmall),
          const SizedBox(height: 8),
          Obx(() => DropdownButtonFormField<String>(
                value: controller.department.value.isEmpty ? null : controller.department.value,
                decoration: InputDecoration(hintText: AppStrings.improveDeptHint),
                items: controller.departments.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                onChanged: (v) => controller.department.value = v ?? '',
              )),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text(AppStrings.improveSuggestionLabel, style: AppTextStyles.titleSmall),
              ),
              IconButton(
                tooltip: 'Expand editor',
                icon: const Icon(Icons.open_in_full_rounded, size: 22),
                onPressed: () =>
                    Get.toNamed(Routes.longFormComposer, arguments: controller.suggestionController),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller.suggestionController,
            minLines: 8,
            maxLines: 16,
            maxLength: 1500,
            decoration: InputDecoration(hintText: AppStrings.improveSuggestionHint),
          ),
          const SizedBox(height: 20),
          Text(AppStrings.addVoiceNote, style: AppTextStyles.titleSmall),
          const SizedBox(height: 8),
          VoiceInputWidget(onRecorded: (path) => controller.voiceRecordingPath.value = path),
          const SizedBox(height: 32),
          PrimaryButton(text: AppStrings.improveNextLocation, onPressed: controller.nextStep, backgroundColor: AppColors.improveBlue),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
