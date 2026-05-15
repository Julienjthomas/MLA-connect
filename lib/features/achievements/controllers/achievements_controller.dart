import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/achievement_model.dart';
import '../../../data/services/achievements_service.dart';

class AchievementsController extends GetxController {
  final _service = AchievementsService();

  final RxList<AchievementEntry> entries = <AchievementEntry>[].obs;
  final RxList<AchievementEntry> pendingEntries = <AchievementEntry>[].obs;
  final RxBool loading = false.obs;

  final nameController = TextEditingController();
  final institutionController = TextEditingController();
  final achievementController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadAchievements();
  }

  @override
  void onClose() {
    nameController.dispose();
    institutionController.dispose();
    achievementController.dispose();
    super.onClose();
  }

  List<AchievementEntry> get allEntries => [...entries, ...pendingEntries];

  Future<void> loadAchievements() async {
    loading.value = true;
    try {
      entries.value = await _service.getAchievers();
    } catch (_) {
      entries.clear();
    } finally {
      loading.value = false;
    }
  }

  bool validateSubmission() {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar('Required', 'Enter the achiever name', snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    if (institutionController.text.trim().isEmpty) {
      Get.snackbar('Required', 'Enter the institution', snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    if (achievementController.text.trim().isEmpty) {
      Get.snackbar('Required', 'Enter the achievement', snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    return true;
  }

  void submitAchievement() {
    if (!validateSubmission()) return;
    pendingEntries.add(
      AchievementEntry(
        name: nameController.text.trim(),
        institution: institutionController.text.trim(),
        achievement: achievementController.text.trim(),
      ),
    );
    nameController.clear();
    institutionController.clear();
    achievementController.clear();
    Get.back();
    Get.snackbar(
      'Submitted',
      'Your achievement has been sent for MLA office review.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
