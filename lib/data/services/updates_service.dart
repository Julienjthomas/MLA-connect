import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../core/constants/app_enums.dart';
import '../../features/auth/controllers/auth_controller.dart';
import '../models/update_model.dart';
import '../remote/updates_api.dart';

class UpdatesService {
  UpdatesApi get _api => Get.find<UpdatesApi>();

  String? get _constituencyId =>
      Get.isRegistered<AuthController>()
          ? Get.find<AuthController>().user.value?.constituencyId
          : null;

  Future<List<UpdateModel>> getUpdates({
    UpdateCategory? category,
    String? constituencyId,
  }) async {
    final cid = constituencyId ?? _constituencyId;
    if (cid == null) return [];
    try {
      final posts = await _api.getPosts(
        cid,
        category: category != null && category != UpdateCategory.all
            ? category.name
            : null,
      );
      return posts.map(_mapPost).toList();
    } catch (e) {
      debugPrint('[UpdatesService] getUpdates error: $e');
      return [];
    }
  }

  Future<UpdateModel?> getUpdate(String id) async {
    final cid = _constituencyId;
    if (cid == null) return null;
    try {
      return _mapPost(await _api.getPost(cid, id));
    } catch (e) {
      debugPrint('[UpdatesService] getUpdate error: $e');
      return null;
    }
  }

  Future<void> likeUpdate(String id) async {
    final cid = _constituencyId;
    if (cid == null) return;
    try {
      await _api.likePost(cid, id);
    } catch (_) {}
  }

  /// No unlike endpoint in contract — no-op for now.
  Future<void> unlikeUpdate(String id) async {}

  /// No view count endpoint in contract — no-op for now.
  Future<void> incrementViewCount(String id) async {}

  /// No liked-posts endpoint in contract — return empty set.
  Future<Set<String>> getLikedPostIds(Iterable<String> postIds) async => {};


  UpdateModel _mapPost(p) => UpdateModel(
        id: p.id,
        title: p.title,
        body: p.body,
        titleMl: p.titleMl,
        bodyMl: p.bodyMl,
        category: UpdateCategoryX.fromString(p.category),
        imageUrl: p.imageUrl,
        mediaUrls: p.mediaUrls,
        likes: p.likes,
        views: p.views,
        isFeatured: p.isFeatured,
        createdAt: p.createdAt,
      );
}
