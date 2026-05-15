import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/services/storage_service.dart';
import '../../../features/onboarding/controllers/onboarding_controller.dart';
import '../../../routes/app_routes.dart';
import 'auth_controller.dart';

class ProfileSetupController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final RxBool loading = false.obs;
  final RxBool uploadingAvatar = false.obs;
  final RxString pickedImagePath = ''.obs;
  final RxString avatarUrl = ''.obs;

  final _picker = ImagePicker();
  final _storageService = StorageService();

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    super.onClose();
  }

  Future<void> pickAndUploadImage() async {
    final uid = Get.find<AuthController>().userId;
    if (uid == null) return;
    final picked = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked == null) return;
    pickedImagePath.value = picked.path;
    uploadingAvatar.value = true;
    try {
      final url = await _storageService.uploadAvatar(File(picked.path), uid);
      avatarUrl.value = url;
    } catch (_) {
      Get.snackbar('Upload failed', 'Could not upload profile picture. Try again.', snackPosition: SnackPosition.BOTTOM);
      pickedImagePath.value = '';
    } finally {
      uploadingAvatar.value = false;
    }
  }

  Future<void> next() async {
    if (!formKey.currentState!.validate()) return;
    loading.value = true;
    try {
      final onboarding = Get.find<OnboardingController>();
      final auth = Get.find<AuthController>();
      final language = auth.user.value?.language ?? 'en';
      await auth.saveProfile(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        avatarUrl: avatarUrl.value.isNotEmpty ? avatarUrl.value : null,
        constituencyId: onboarding.selectedConstituency.value?.id ?? auth.user.value?.constituencyId,
        localBodyId: onboarding.selectedLocalBody.value!.id,
        wardId: onboarding.selectedWard.value!.id,
        language: language,
      );
      Get.toNamed(Routes.notificationsSetup);
    } catch (_) {
      Get.snackbar('Error', 'Failed to save profile. Please try again.', snackPosition: SnackPosition.BOTTOM);
    } finally {
      loading.value = false;
    }
  }
}
