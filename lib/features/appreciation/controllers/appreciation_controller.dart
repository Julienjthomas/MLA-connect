import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/app_enums.dart';
import '../../../data/models/appreciation_model.dart';
import '../../../data/services/appreciation_service.dart';
import '../../../data/services/storage_service.dart';
import '../../auth/controllers/auth_controller.dart';

class AppreciationController extends GetxController {
  final _service = AppreciationService();
  final _storage = StorageService();

  // Form state
  final RxString recipientCategory = ''.obs;
  final staffController = TextEditingController();
  final departmentController = TextEditingController();
  final relatedWorkController = TextEditingController();
  final messageController = TextEditingController();
  final Rx<SubmissionVisibility> visibility = SubmissionVisibility.public.obs;
  final RxBool anonymous = false.obs;
  final RxList<XFile> selectedImages = <XFile>[].obs;

  // Flow state
  final RxInt currentStep = 0.obs;
  final RxBool isSubmitting = false.obs;
  final RxString submittedId = ''.obs;
  late PageController pageController;

  final List<String> steps = ['Recipient', 'Message', 'Visibility', 'Review', 'Done'];

  final List<String> recipientCategories = [
    'Government Staff', 'PWD Department', 'Health Department',
    'Education Department', 'Panchayat Office', 'Police', 'Other',
  ];

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
  }

  @override
  void onClose() {
    staffController.dispose();
    departmentController.dispose();
    relatedWorkController.dispose();
    messageController.dispose();
    pageController.dispose();
    super.onClose();
  }

  bool validateCurrentStep() {
    switch (currentStep.value) {
      case 0:
        if (recipientCategory.value.isEmpty) {
          Get.snackbar('Required', 'Please select a recipient category', snackPosition: SnackPosition.BOTTOM);
          return false;
        }
        return true;
      case 1:
        if (messageController.text.trim().length < 10) {
          Get.snackbar('Required', 'Please write an appreciation message (at least 10 characters)', snackPosition: SnackPosition.BOTTOM);
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

  bool get _hasUnsavedData =>
      recipientCategory.value.isNotEmpty ||
      staffController.text.isNotEmpty ||
      messageController.text.isNotEmpty;

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
      pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else if (_hasUnsavedData) {
      Get.dialog(AlertDialog(
        title: const Text('Discard appreciation?'),
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
      final reporterId = Get.find<AuthController>().submissionReporterId ?? '';
      if (reporterId.isEmpty) {
        Get.snackbar('Error', 'Profile not ready. Please sign in again.', snackPosition: SnackPosition.BOTTOM);
        return;
      }
      List<String> mediaUrls = [];
      if (selectedImages.isNotEmpty) {
        mediaUrls = await _storage.uploadFiles(selectedImages, 'appreciations');
      }
      final data = AppreciationFormData(
        recipientCategory: recipientCategory.value,
        staffName: staffController.text.trim(),
        department: departmentController.text.trim(),
        relatedWork: relatedWorkController.text.trim(),
        message: messageController.text.trim(),
        visibility: visibility.value,
        anonymous: anonymous.value,
        mediaUrls: mediaUrls,
      );
      final id = await _service.submit(data, reporterId);
      submittedId.value = id;
      nextStep();
    } catch (e) {
      Get.snackbar('Error', 'Failed to submit. Please try again.', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isSubmitting.value = false;
    }
  }
}
