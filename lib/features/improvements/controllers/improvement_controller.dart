import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/models/improvement_model.dart';
import '../../../data/services/improvement_service.dart';
import '../../activity/controllers/activity_controller.dart';
import '../../auth/controllers/auth_controller.dart';

class ImprovementController extends GetxController {
  final _service = ImprovementService();

  final suggestionController = TextEditingController();
  final RxString department = ''.obs;
  final RxString voiceRecordingPath = ''.obs;
  final RxString selectedPanchayath = ''.obs;
  final RxString selectedWard = ''.obs;
  final locationController = TextEditingController();
  final landmarkController = TextEditingController();
  final RxBool isLoadingLocation = false.obs;

  final RxInt currentStep = 0.obs;
  final RxBool isSubmitting = false.obs;
  final RxString submittedId = ''.obs;
  late PageController pageController;

  List<String> get steps => [AppStrings.stepSuggestion, AppStrings.stepLocation, AppStrings.stepReview, AppStrings.stepDone];
  final List<String> departments = [
    'Roads & Infrastructure', 'Water Supply', 'Electricity', 'Health',
    'Education', 'Waste Management', 'Agriculture', 'Panchayat Office', 'Other',
  ];

  @override
  void onInit() { super.onInit(); pageController = PageController(); }

  @override
  void onClose() {
    suggestionController.dispose();
    locationController.dispose();
    landmarkController.dispose();
    pageController.dispose();
    super.onClose();
  }

  bool validateCurrentStep() {
    switch (currentStep.value) {
      case 0:
        if (suggestionController.text.trim().length < 10) {
          Get.snackbar('Required', 'Please describe your suggestion', snackPosition: SnackPosition.BOTTOM);
          return false;
        }
        return true;
      default:
        return true;
    }
  }

  void nextStep() {
    if (!validateCurrentStep()) return;
    if (currentStep.value < steps.length - 1) {
      currentStep.value++;
      pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  bool get _hasUnsavedData => suggestionController.text.isNotEmpty;

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
      pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else if (_hasUnsavedData) {
      Get.dialog(AlertDialog(
        title: const Text('Discard suggestion?'),
        content: const Text('Your progress will be lost.'),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Keep editing')),
          TextButton(onPressed: () { Get.back(); Get.back(); }, child: const Text('Discard')),
        ],
      ));
    } else {
      Get.back();
    }
  }

  Future<void> submit() async {
    isSubmitting.value = true;
    try {
      final auth = Get.find<AuthController>();
      final reporterId = auth.submissionReporterId;
      if (reporterId == null || reporterId.isEmpty) {
        Get.snackbar('Error', 'Profile not ready. Please sign in again.', snackPosition: SnackPosition.BOTTOM);
        return;
      }

      final data = ImprovementFormData(
        suggestion: suggestionController.text.trim(),
        department: department.value,
        location: locationController.text.trim(),
        landmark: landmarkController.text.trim(),
      );
      final id = await _service.submit(data, reporterId);
      submittedId.value = id;
      if (Get.isRegistered<ActivityController>()) {
        unawaited(Get.find<ActivityController>().loadActivity());
      }
      nextStep();
    } catch (_) {
      Get.snackbar('Error', 'Failed to submit. Please try again.', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isSubmitting.value = false;
    }
  }
}
