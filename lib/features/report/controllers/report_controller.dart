import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/app_enums.dart';
import '../../../data/models/report_model.dart';
import '../../../data/services/report_service.dart';
import '../../../data/services/storage_service.dart';
import '../../auth/controllers/auth_controller.dart';

class ReportController extends GetxController {
  final _service = ReportService();
  final _storage = StorageService();

  // Form state
  final Rx<ReportCategory?> selectedCategory = Rx(null);
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();
  final landmarkController = TextEditingController();
  final contactController = TextEditingController();
  final RxList<XFile> selectedImages = <XFile>[].obs;
  final RxBool isLoadingLocation = false.obs;

  // Flow state
  final RxInt currentStep = 0.obs;
  final RxBool isSubmitting = false.obs;
  final RxString submittedId = ''.obs;

  late PageController pageController;

  final List<String> steps = ['Details', 'Location', 'Review', 'Done'];

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    landmarkController.dispose();
    contactController.dispose();
    pageController.dispose();
    super.onClose();
  }

  bool validateCurrentStep() {
    switch (currentStep.value) {
      case 0:
        if (selectedCategory.value == null) {
          Get.snackbar('Required', 'Please select a category', snackPosition: SnackPosition.BOTTOM);
          return false;
        }
        if (titleController.text.trim().length < 5) {
          Get.snackbar('Required', 'Please describe the problem (at least 5 characters)', snackPosition: SnackPosition.BOTTOM);
          return false;
        }
        return true;
      case 1:
        if (locationController.text.trim().isEmpty) {
          Get.snackbar('Required', 'Please add a location', snackPosition: SnackPosition.BOTTOM);
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

      // Upload images
      List<String> mediaUrls = [];
      if (selectedImages.isNotEmpty) {
        mediaUrls = await _storage.uploadFiles(selectedImages, 'reports');
      }

      final data = ReportFormData(
        category: selectedCategory.value!,
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        location: locationController.text.trim(),
        landmark: landmarkController.text.trim(),
        contactNumber: contactController.text.trim(),
        mediaUrls: mediaUrls,
      );

      final id = await _service.submitReport(data, userId);
      submittedId.value = id;
      nextStep(); // go to success step
    } catch (e) {
      Get.snackbar('Error', 'Failed to submit. Please try again.',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> useCurrentLocation() async {
    isLoadingLocation.value = true;
    try {
      // Simplified — in production use geolocator
      await Future.delayed(const Duration(seconds: 1));
      locationController.text = 'Current location (GPS)';
    } catch (_) {
      Get.snackbar('Error', 'Could not get location', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoadingLocation.value = false;
    }
  }
}
