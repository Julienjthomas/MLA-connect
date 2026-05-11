import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/kerala_app_bar.dart';
import '../../../core/widgets/stepper_header.dart';
import '../controllers/appreciation_controller.dart';
import 'steps/recipient_step.dart';
import 'steps/message_step.dart';
import 'steps/visibility_step.dart';
import 'steps/appreciation_review_step.dart';
import 'steps/appreciation_success_step.dart';

class AppreciationFlowView extends GetView<AppreciationController> {
  const AppreciationFlowView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) { if (!didPop) controller.previousStep(); },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: Obx(() => controller.currentStep.value == controller.steps.length - 1
                ? const SizedBox.shrink()
                : KeralaAppBar(title: 'Submit Appreciation', onBack: controller.previousStep)),
          ),
          body: Column(
            children: [
              Obx(() => controller.currentStep.value < controller.steps.length - 1
                  ? StepperHeader(steps: controller.steps, currentStep: controller.currentStep.value, accentColor: AppColors.appreciateGreen)
                  : const SizedBox()),
              Expanded(
                child: PageView(
                  controller: controller.pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: const [
                    RecipientStep(), MessageStep(), AppreciationVisibilityStep(),
                    AppreciationReviewStep(), AppreciationSuccessStep(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
