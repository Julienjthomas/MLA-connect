import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/app_enums.dart';
import '../../../data/models/report_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/report_service.dart';
import '../../../data/services/storage_service.dart';
import '../../../data/services/user_service.dart';
import '../../../core/constants/app_strings.dart';
import '../../activity/controllers/activity_controller.dart';
import '../../auth/controllers/auth_controller.dart';

class ReportController extends GetxController {
  final _service = ReportService();
  final _storage = StorageService();
  final _userService = UserService();

  // Form state
  final Rx<ReportCategory?> selectedCategory = Rx(null);
  final customCategoryController = TextEditingController();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();
  final landmarkController = TextEditingController();
  final contactController = TextEditingController();
  final RxString selectedPanchayath = ''.obs;
  final RxString selectedWard = ''.obs;

  // Location synced with DB (like onboarding/improvements)
  final RxList<LocalBodyModel> localBodies = <LocalBodyModel>[].obs;
  final RxList<WardModel> wards = <WardModel>[].obs;
  final Rx<LocalBodyModel?> selectedLocalBody = Rx(null);
  final Rx<WardModel?> selectedWardModel = Rx(null);
  final RxBool loadingLocalBodies = false.obs;
  final RxBool loadingWards = false.obs;
  final RxList<XFile> selectedImages = <XFile>[].obs;
  final RxBool isLoadingLocation = false.obs;
  final Rx<SubmissionVisibility> visibility = SubmissionVisibility.public.obs;
  final RxnString voiceRecordingPath = RxnString();

  // Flow state
  final RxInt currentStep = 0.obs;
  final RxBool isSubmitting = false.obs;
  final RxString submittedId = ''.obs;

  late PageController pageController;

  List<String> get steps => [AppStrings.stepDetails, AppStrings.stepVisibility, AppStrings.stepReview, AppStrings.stepDone];

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
    _loadLocationData();
  }

  Future<void> _loadLocationData() async {
    final profile = Get.find<AuthController>().user.value;
    loadingLocalBodies.value = true;
    try {
      localBodies.value =
          await _userService.getLocalBodies(constituencyId: profile?.constituencyId);
    } catch (_) {
      localBodies.value = [];
    } finally {
      loadingLocalBodies.value = false;
    }
    // Preselect user's saved local body if present.
    final savedId = profile?.localBodyId;
    if (savedId != null) {
      final match = localBodies.firstWhereOrNull((e) => e.id == savedId);
      if (match != null) await selectLocalBody(match);
    }
  }

  Future<void> selectLocalBody(LocalBodyModel lb) async {
    selectedLocalBody.value = lb;
    selectedPanchayath.value = lb.name;
    selectedWardModel.value = null;
    selectedWard.value = '';
    wards.clear();
    loadingWards.value = true;
    try {
      wards.value = await _userService.getWards(
        lb.id,
        constituencyId: Get.find<AuthController>().user.value?.constituencyId,
        localBodyName: lb.name,
      );
    } catch (_) {
      wards.value = [];
    } finally {
      loadingWards.value = false;
    }
  }

  void selectWardModel(WardModel w) {
    selectedWardModel.value = w;
    selectedWard.value = w.displayName;
  }

  @override
  void onClose() {
    customCategoryController.dispose();
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
        if (selectedCategory.value == ReportCategory.other &&
            customCategoryController.text.trim().isEmpty) {
          Get.snackbar('Required', 'Please enter a category', snackPosition: SnackPosition.BOTTOM);
          return false;
        }
        if (titleController.text.trim().length < 5) {
          Get.snackbar('Required', 'Please describe the problem (at least 5 characters)', snackPosition: SnackPosition.BOTTOM);
          return false;
        }
        if (selectedPanchayath.value.isEmpty) {
          Get.snackbar('Required', 'Please select a panchayath', snackPosition: SnackPosition.BOTTOM);
          return false;
        }
        if (selectedWard.value.isEmpty) {
          Get.snackbar('Required', 'Please select a ward', snackPosition: SnackPosition.BOTTOM);
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
      selectedCategory.value != null ||
      customCategoryController.text.isNotEmpty ||
      titleController.text.isNotEmpty ||
      descriptionController.text.isNotEmpty;

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
      pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else if (_hasUnsavedData) {
      Get.dialog(AlertDialog(
        title: const Text('Discard report?'),
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

      final uid = auth.userId;
      if (uid == null || uid.isEmpty) {
        Get.snackbar('Error', 'Profile not ready. Please sign in again.', snackPosition: SnackPosition.BOTTOM);
        return;
      }

      // Upload images → submission-objects/problems/{userId}/…
      List<String> mediaUrls = [];
      if (selectedImages.isNotEmpty) {
        mediaUrls = await _storage.uploadSubmissionFiles(
          selectedImages.toList(),
          folder: SubmissionObjectsFolder.problems,
          userId: uid,
        );
      }

      String? voiceMessageUrl;
      final voicePath = voiceRecordingPath.value;
      if (voicePath != null && voicePath.isNotEmpty) {
        voiceMessageUrl = await _storage.uploadVoiceFile(
          voicePath,
          folder: SubmissionObjectsFolder.problems,
          userId: uid,
        );
      }

      final profile = auth.user.value;
      final landmarkText = landmarkController.text.trim();
      final geoLabel = [
        if (selectedPanchayath.value.isNotEmpty) selectedPanchayath.value,
        if (selectedWard.value.isNotEmpty) selectedWard.value,
      ].join(' · ');
      final mergedLandmark = landmarkText.isEmpty
          ? (geoLabel.isEmpty ? null : geoLabel)
          : (geoLabel.isEmpty ? landmarkText : '$landmarkText ($geoLabel)');

      final category = selectedCategory.value!;
      final data = ReportFormData(
        category: category,
        customCategory: category == ReportCategory.other
            ? customCategoryController.text.trim()
            : null,
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        location: locationController.text.trim(),
        landmark: mergedLandmark,
        localBodyId: selectedLocalBody.value?.id ?? profile?.localBodyId,
        wardId: selectedWardModel.value?.id ?? profile?.wardId,
        panchayath: selectedPanchayath.value,
        ward: selectedWard.value,
        contactNumber: contactController.text.trim(),
        mediaUrls: mediaUrls,
        voiceMessageUrl: voiceMessageUrl,
        visibility: visibility.value,
      );

      final id = await _service.submitReport(data, reporterId);
      submittedId.value = id;
      if (Get.isRegistered<ActivityController>()) {
        unawaited(Get.find<ActivityController>().loadActivity());
      }
      nextStep();
    } catch (e) {
      Get.snackbar('Error', 'Failed to submit. Please try again.',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isSubmitting.value = false;
    }
  }
}
