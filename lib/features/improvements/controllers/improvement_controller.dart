import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/models/improvement_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/improvement_service.dart';
import '../../../data/services/user_service.dart';
import '../../activity/controllers/activity_controller.dart';
import '../../auth/controllers/auth_controller.dart';

class ImprovementController extends GetxController {
  final _service = ImprovementService();
  final _userService = UserService();

  final suggestionController = TextEditingController();
  final RxString department = ''.obs;
  final RxString voiceRecordingPath = ''.obs;
  final RxString selectedPanchayath = ''.obs;
  final RxString selectedWard = ''.obs;
  final locationController = TextEditingController();
  final landmarkController = TextEditingController();
  final RxBool isLoadingLocation = false.obs;

  // Location synced with DB (like onboarding/report)
  final RxList<LocalBodyModel> localBodies = <LocalBodyModel>[].obs;
  final RxList<WardModel> wards = <WardModel>[].obs;
  final Rx<LocalBodyModel?> selectedLocalBody = Rx(null);
  final Rx<WardModel?> selectedWardModel = Rx(null);
  final RxBool loadingLocalBodies = false.obs;
  final RxBool loadingWards = false.obs;

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

      final profile = auth.user.value;
      final landmarkText = landmarkController.text.trim();
      final geoLabel = [
        if (selectedPanchayath.value.isNotEmpty) selectedPanchayath.value,
        if (selectedWard.value.isNotEmpty) selectedWard.value,
      ].join(' · ');
      final mergedLandmark = landmarkText.isEmpty
          ? geoLabel
          : (geoLabel.isEmpty ? landmarkText : '$landmarkText ($geoLabel)');

      final data = ImprovementFormData(
        suggestion: suggestionController.text.trim(),
        department: department.value,
        location: locationController.text.trim(),
        landmark: mergedLandmark,
        localBodyId: selectedLocalBody.value?.id ?? profile?.localBodyId,
        wardId: selectedWardModel.value?.id ?? profile?.wardId,
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
