import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/kerala_app_bar.dart';
import '../../../core/widgets/stepper_header.dart';
import '../controllers/improvement_controller.dart';
import 'steps/suggestion_step.dart';
import 'steps/improvement_location_step.dart';
import 'steps/improvement_review_step.dart';
import 'steps/improvement_success_step.dart';

class ImprovementFlowView extends GetView<ImprovementController> {
  const ImprovementFlowView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          if (controller.currentStep.value == controller.steps.length - 1) {
            Get.until((r) => r.settings.name == '/home');
          } else {
            controller.previousStep();
          }
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Obx(() => controller.currentStep.value == controller.steps.length - 1
              ? const SizedBox.shrink()
              : KeralaAppBar(title: AppStrings.suggestImprovement, onBack: controller.previousStep)),
        ),
        body: Column(
          children: [
            Obx(() => controller.currentStep.value < controller.steps.length - 1
                ? StepperHeader(steps: controller.steps, currentStep: controller.currentStep.value, accentColor: AppColors.improveBlue)
                : const SizedBox()),
            Expanded(
              child: PageView(
                controller: controller.pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: const [SuggestionStep(), ImprovementLocationStep(), ImprovementReviewStep(), ImprovementSuccessStep()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
