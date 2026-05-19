import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_enums.dart';
import '../../../data/models/update_model.dart';
import '../../../data/services/updates_service.dart';

class UpdatesController extends GetxController {
  final _service = UpdatesService();

  final RxList<UpdateModel> updates = <UpdateModel>[].obs;
  final Rx<UpdateCategory> selectedCategory = UpdateCategory.all.obs;
  final RxBool loading = false.obs;
  final RxString error = ''.obs;
  final Rx<UpdateModel?> selectedUpdate = Rx(null);
  final RxSet<String> likedIds = <String>{}.obs;
  final ScrollController filterScrollController = ScrollController();

  @override
  void onClose() {
    filterScrollController.dispose();
    super.onClose();
  }

  List<UpdateModel> get filteredUpdates {
    if (selectedCategory.value == UpdateCategory.all) return updates;
    return updates.where((u) => u.category == selectedCategory.value).toList();
  }

  @override
  void onInit() {
    super.onInit();
    loadUpdates();
  }

  Future<void> loadUpdates() async {
    loading.value = true;
    error.value = '';
    try {
      final list = await _service.getUpdates();
      updates.value = list;
      likedIds
        ..clear()
        ..addAll(await _service.getLikedPostIds(updates.map((u) => u.id)));
    } catch (_) {
      updates.value = [];
      likedIds.clear();
      error.value = 'Could not load updates. Please try again.';
    } finally {
      loading.value = false;
    }
  }

  void selectCategory(UpdateCategory cat) {
    selectedCategory.value = cat;
    // Scroll filter row so selected chip is visible. Each chip ~90px wide + 8px margin.
    final idx = UpdateCategory.values.indexOf(cat);
    final offset = (idx * 98.0).clamp(0.0, double.infinity);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (filterScrollController.hasClients) {
        filterScrollController.animateTo(
          offset,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> toggleLike(String id) async {
    final idx = updates.indexWhere((u) => u.id == id);
    if (idx == -1) return;
    final u = updates[idx];
    final wasLiked = likedIds.contains(id);
    final previousLikes = u.likes;

    if (wasLiked) {
      likedIds.remove(id);
      updates[idx] = _copyUpdate(u, likes: (u.likes - 1).clamp(0, 999999));
    } else {
      likedIds.add(id);
      updates[idx] = _copyUpdate(u, likes: u.likes + 1);
    }

    try {
      if (wasLiked) {
        await _service.unlikeUpdate(id);
      } else {
        await _service.likeUpdate(id);
      }
    } catch (_) {
      if (wasLiked) {
        likedIds.add(id);
      } else {
        likedIds.remove(id);
      }
      updates[idx] = _copyUpdate(u, likes: previousLikes);
      Get.snackbar('Error', 'Could not update like. Please try again.', snackPosition: SnackPosition.BOTTOM);
    }
  }

  UpdateModel _copyUpdate(UpdateModel u, {required int likes}) => UpdateModel(
        id: u.id,
        title: u.title,
        body: u.body,
        titleMl: u.titleMl,
        bodyMl: u.bodyMl,
        category: u.category,
        imageUrl: u.imageUrl,
        mediaUrls: u.mediaUrls,
        likes: likes,
        views: u.views,
        createdAt: u.createdAt,
      );

}
