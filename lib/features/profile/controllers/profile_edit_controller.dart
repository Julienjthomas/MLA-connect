import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/services/storage_service.dart';
import '../../auth/controllers/auth_controller.dart';

class ProfileEditController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final RxBool loading = false.obs;
  final RxBool uploadingAvatar = false.obs;
  final RxString pickedImagePath = ''.obs;
  final RxString avatarUrl = ''.obs;

  final _picker = ImagePicker();
  final _storageService = StorageService();

  /// Days until the citizen can change their ward again (null = no restriction).
  int? get wardCoolOffDaysRemaining {
    final user = Get.find<AuthController>().user.value;
    final wardUpdatedAt = user?.wardUpdatedAt;
    if (wardUpdatedAt == null) return null;
    final daysSince = DateTime.now().difference(wardUpdatedAt).inDays;
    final remaining = 365 - daysSince;
    return remaining > 0 ? remaining : null;
  }

  bool get canChangeWard => wardCoolOffDaysRemaining == null;

  @override
  void onInit() {
    super.onInit();
    final user = Get.find<AuthController>().user.value;
    nameController.text = user?.name ?? '';
    emailController.text = user?.email ?? '';
    avatarUrl.value = user?.avatarUrl ?? '';
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    super.onClose();
  }

  Future<void> pickAndUploadAvatar() async {
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

  Future<void> save() async {
    if (!formKey.currentState!.validate()) return;
    loading.value = true;
    try {
      final auth = Get.find<AuthController>();
      final uid = auth.userId;
      if (uid == null) return;
      final updates = <String, dynamic>{
        'full_name': nameController.text.trim(),
        if (emailController.text.trim().isNotEmpty) 'email': emailController.text.trim(),
        if (avatarUrl.value.isNotEmpty) 'avatar_url': avatarUrl.value,
      };
      await auth.updateBasicProfile(updates);
      Get.back();
    } catch (_) {
      Get.snackbar('Error', 'Failed to save profile. Please try again.', snackPosition: SnackPosition.BOTTOM);
    } finally {
      loading.value = false;
    }
  }
}
