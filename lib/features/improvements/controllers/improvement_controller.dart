import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/improvement_model.dart';
import '../../../data/services/improvement_service.dart';
import '../../auth/controllers/auth_controller.dart';

class ImprovementController extends GetxController {
  final _service = ImprovementService();

  final suggestionController = TextEditingController();
  final RxString department = ''.obs;
  final locationController = TextEditingController();
  final landmarkController = TextEditingController();
  final RxBool isLoadingLocation = false.obs;

  final RxInt currentStep = 0.obs;
  final RxBool isSubmitting = false.obs;
  final RxString submittedId = ''.obs;
  late PageController pageController;

  final List<String> steps = ['Suggestion', 'Location', 'Review', 'Done'];
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

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
      pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      Get.back();
    }
  }

  Future<void> submit() async {
    isSubmitting.value = true;
    try {
      final userId = Get.find<AuthController>().userId ?? '';
      final data = ImprovementFormData(
        suggestion: suggestionController.text.trim(),
        department: department.value,
        location: locationController.text.trim(),
        landmark: landmarkController.text.trim(),
      );
      final id = await _service.submit(data, userId);
      submittedId.value = id;
      nextStep();
    } catch (_) {
      Get.snackbar('Error', 'Failed to submit. Please try again.', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isSubmitting.value = false;
    }
  }
}
