import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/app_enums.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/models/appreciation_model.dart';
import '../../../data/services/appreciation_service.dart';
import '../../../data/services/mla_service.dart';
import '../../../data/services/storage_service.dart';
import '../../activity/controllers/activity_controller.dart';
import '../../auth/controllers/auth_controller.dart';

/// A selectable appreciation recipient: the MLA or a member of MLA's direct staff.
class AppreciationRecipient {
  final String type; // 'mla' | 'staff'
  final String id;
  final String name;
  final String? designation;
  final String? photoUrl;

  const AppreciationRecipient({
    required this.type,
    required this.id,
    required this.name,
    this.designation,
    this.photoUrl,
  });
}

class AppreciationController extends GetxController {
  final _service = AppreciationService();
  final _storage = StorageService();
  final _mlaService = MlaService();

  // Form state
  final RxString recipientCategory = ''.obs;
  final Rxn<AppreciationRecipient> selectedRecipient = Rxn<AppreciationRecipient>();
  final RxList<AppreciationRecipient> recipients = <AppreciationRecipient>[].obs;
  final RxBool loadingRecipients = false.obs;
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

  List<String> get steps => [AppStrings.stepRecipient, AppStrings.stepReview, AppStrings.stepDone];

  final List<String> recipientCategories = [
    'Government Staff', 'PWD Department', 'Health Department',
    'Education Department', 'Panchayat Office', 'Police', 'Other',
  ];

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
    loadRecipients();
  }

  Future<void> loadRecipients() async {
    loadingRecipients.value = true;
    try {
      final list = <AppreciationRecipient>[];
      final cid = Get.find<AuthController>().user.value?.constituencyId;
      final mla = await _mlaService.getMlaProfile(constituencyId: cid);
      if (mla != null) {
        list.add(AppreciationRecipient(
          type: 'mla',
          id: mla.id,
          name: mla.name,
          designation: 'MLA',
          photoUrl: mla.photoUrl,
        ));
      }
      final staff = await _mlaService.getPublicStaff();
      for (final s in staff) {
        list.add(AppreciationRecipient(
          type: 'staff',
          id: s.id,
          name: s.fullName,
          designation: s.designation,
          photoUrl: s.photoUrl,
        ));
      }
      recipients.value = list;
    } catch (_) {
      // leave empty — UI will show empty state
    } finally {
      loadingRecipients.value = false;
    }
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
    if (currentStep.value == 0 && recipientCategory.value.isEmpty) {
      Get.snackbar('Required', 'Please select a category', snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    return true;
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
          folder: SubmissionObjectsFolder.appreciations,
          userId: uid,
        );
      }
      final data = AppreciationFormData(
        recipientCategory: recipientCategory.value,
        staffName: '',
        department: '',
        relatedWork: '',
        message: messageController.text.trim(),
        visibility: visibility.value,
        anonymous: anonymous.value,
        mediaUrls: mediaUrls,
      );
      final id = await _service.submit(data, reporterId);
      submittedId.value = id;
      if (Get.isRegistered<ActivityController>()) {
        unawaited(Get.find<ActivityController>().loadActivity());
      }
      nextStep();
    } catch (e) {
      Get.snackbar('Error', 'Failed to submit. Please try again.', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isSubmitting.value = false;
    }
  }
}
