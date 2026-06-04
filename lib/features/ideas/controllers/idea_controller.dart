import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/app_enums.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/models/idea_model.dart';
import '../../../data/services/idea_service.dart';
import '../../../data/services/storage_service.dart';
import '../../activity/controllers/activity_controller.dart';
import '../../auth/controllers/auth_controller.dart';

class IdeaController extends GetxController {
  final _service = IdeaService();
  final _storage = StorageService();

  // Form state
  final RxString topic = ''.obs;
  final customTopicController = TextEditingController();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final benefitsController = TextEditingController();
  final RxList<String> beneficiaries = <String>[].obs;
  final RxString estimatedResources = ''.obs;
  final Rx<SubmissionVisibility> visibility = SubmissionVisibility.public.obs;
  final RxBool allowDiscussion = true.obs;
  final RxBool allowContact = true.obs;
  final RxList<XFile> selectedImages = <XFile>[].obs;
  final RxString voiceRecordingPath = ''.obs;

  // Flow state
  final RxInt currentStep = 0.obs;
  final RxBool isSubmitting = false.obs;
  final RxString submittedId = ''.obs;
  late PageController pageController;

  List<String> get steps => [AppStrings.stepDetails, AppStrings.stepImpact, AppStrings.stepVisibility, AppStrings.stepReview, AppStrings.stepDone];

  final List<String> topics = [
    'Infrastructure', 'Education', 'Health', 'Environment',
    'Agriculture', 'Tourism', 'Digital Services', 'Other',
  ];

  final List<String> allBeneficiaries = [
    'Residents', 'Students', 'Business Owners', 'Farmers',
    'Senior Citizens', 'Women', 'Youth', 'Differently Abled',
  ];

  final List<String> resourceRanges = [
    'Under ₹1 Lakh', '₹1–5 Lakhs', '₹5–10 Lakhs',
    '₹10–25 Lakhs', '₹25 Lakhs – 1 Crore', 'Above ₹1 Crore',
  ];

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
  }

  @override
  void onClose() {
    customTopicController.dispose();
    titleController.dispose();
    descriptionController.dispose();
    benefitsController.dispose();
    pageController.dispose();
    super.onClose();
  }

  void toggleBeneficiary(String b) {
    if (beneficiaries.contains(b)) {
      beneficiaries.remove(b);
    } else {
      beneficiaries.add(b);
    }
  }

  bool validateCurrentStep() {
    switch (currentStep.value) {
      case 0:
        if (topic.value.isEmpty) {
          Get.snackbar('Required', 'Please select a topic', snackPosition: SnackPosition.BOTTOM);
          return false;
        }
        if (topic.value == 'Other' && customTopicController.text.trim().isEmpty) {
          Get.snackbar('Required', 'Please enter a custom topic', snackPosition: SnackPosition.BOTTOM);
          return false;
        }
        if (titleController.text.trim().length < 5) {
          Get.snackbar('Required', 'Please enter an idea title', snackPosition: SnackPosition.BOTTOM);
          return false;
        }
        return true;
      case 1:
        if (benefitsController.text.trim().isEmpty) {
          Get.snackbar('Required', 'Please describe the benefits', snackPosition: SnackPosition.BOTTOM);
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
      topic.value.isNotEmpty ||
      titleController.text.isNotEmpty ||
      descriptionController.text.isNotEmpty ||
      selectedImages.isNotEmpty;

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
      pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else if (_hasUnsavedData) {
      Get.dialog(AlertDialog(
        title: const Text('Discard idea?'),
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
      final reporterId = auth.submissionReporterId ?? '';
      if (reporterId.isEmpty) {
        Get.snackbar('Error', 'Profile not ready. Please sign in again.', snackPosition: SnackPosition.BOTTOM);
        return;
      }
      final uid = auth.userId;
      if (uid == null || uid.isEmpty) {
        Get.snackbar('Error', 'Profile not ready. Please sign in again.', snackPosition: SnackPosition.BOTTOM);
        return;
      }
      List<String> mediaUrls = [];
      if (selectedImages.isNotEmpty) {
        mediaUrls = await _storage.uploadSubmissionFiles(
          selectedImages.toList(),
          folder: SubmissionObjectsFolder.ideas,
          userId: uid,
        );
      }
      final effectiveTopic = topic.value == 'Other'
          ? customTopicController.text.trim()
          : topic.value;
      final data = IdeaFormData(
        topic: effectiveTopic,
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        benefits: benefitsController.text.trim(),
        beneficiaries: List.from(beneficiaries),
        visibility: visibility.value,
        allowDiscussion: allowDiscussion.value,
        allowContact: allowContact.value,
        mediaUrls: mediaUrls,
      );
      final id = await _service.submit(data, reporterId);
      submittedId.value = id;
      Get.find<AuthController>().incrementContributionCount();
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
