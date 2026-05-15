import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/kerala_app_bar.dart';
import '../../../core/widgets/stepper_header.dart';
import '../controllers/report_controller.dart';
import 'steps/report_details_step.dart';
import 'steps/report_visibility_step.dart';
import 'steps/report_review_step.dart';
import 'steps/report_success_step.dart';

class ReportFlowView extends GetView<ReportController> {
  const ReportFlowView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) controller.previousStep();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Obx(() => controller.currentStep.value == controller.steps.length - 1
              ? const SizedBox.shrink()
              : KeralaAppBar(title: 'Report a Problem', onBack: controller.previousStep)),
        ),
        body: Column(
          children: [
            Obx(() => controller.currentStep.value < controller.steps.length - 1
                ? StepperHeader(
                    steps: controller.steps,
                    currentStep: controller.currentStep.value,
                    accentColor: AppColors.reportOrange,
                  )
                : const SizedBox()),
            Expanded(
              child: PageView(
                controller: controller.pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  ReportDetailsStep(),
                  ReportVisibilityStep(),
                  ReportReviewStep(),
                  ReportSuccessStep(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
