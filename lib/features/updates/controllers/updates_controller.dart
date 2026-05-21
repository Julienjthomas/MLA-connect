import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/app_enums.dart';
import '../../../data/models/update_model.dart';
import '../../../data/services/updates_service.dart';

enum UpdatesTab { feeds, eventsAnnouncements, publicBoards }

class UpdatesController extends GetxController with GetSingleTickerProviderStateMixin {
  final _service = UpdatesService();

  final RxList<UpdateModel> updates = <UpdateModel>[].obs;
  final Rx<UpdateCategory> selectedCategory = UpdateCategory.all.obs;
  final RxBool loading = false.obs;
  final RxString error = ''.obs;
  final Rx<UpdateModel?> selectedUpdate = Rx(null);
  final RxSet<String> likedIds = <String>{}.obs;

  late final TabController tabController;

  RealtimeChannel? _postsChannel;

  @override
  void onClose() {
    _postsChannel?.unsubscribe();
    tabController.dispose();
    super.onClose();
  }

  List<UpdateModel> get filteredUpdates {
    final tab = UpdatesTab.values[tabController.index];
    return switch (tab) {
      UpdatesTab.feeds => updates.toList(),
      UpdatesTab.eventsAnnouncements => updates
          .where((u) => u.category == UpdateCategory.events || u.category == UpdateCategory.announcements)
          .toList(),
      UpdatesTab.publicBoards => updates.where((u) => u.category == UpdateCategory.publicBoard).toList(),
    };
  }

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      updates.refresh();
    });
    loadUpdates();
    _subscribeRealtime();
  }

  void _subscribeRealtime() {
    _postsChannel = Supabase.instance.client
        .channel('public:posts')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'posts',
          callback: (_) => loadUpdates(),
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'posts',
          callback: (_) => loadUpdates(),
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.delete,
          schema: 'public',
          table: 'posts',
          callback: (_) => loadUpdates(),
        )
        .subscribe();
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

  UpdateModel _copyUpdate(UpdateModel u, {required int likes, int? views}) => UpdateModel(
        id: u.id,
        title: u.title,
        body: u.body,
        titleMl: u.titleMl,
        bodyMl: u.bodyMl,
        category: u.category,
        imageUrl: u.imageUrl,
        mediaUrls: u.mediaUrls,
        likes: likes,
        views: views ?? u.views,
        isFeatured: u.isFeatured,
        createdAt: u.createdAt,
      );

  List<UpdateModel> get featuredUpdates => updates.where((u) => u.isFeatured).toList();

  Future<void> incrementView(String id) async {
    final idx = updates.indexWhere((u) => u.id == id);
    if (idx != -1) {
      final u = updates[idx];
      updates[idx] = _copyUpdate(u, likes: u.likes, views: u.views + 1);
    }
    await _service.incrementViewCount(id);
  }

}
