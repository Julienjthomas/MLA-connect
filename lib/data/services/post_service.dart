import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../features/auth/controllers/auth_controller.dart';
import '../models/post/post_response.dart';

class PostService {
  Dio get _dio => Get.find<Dio>();

  String? get _constituencyId =>
      Get.isRegistered<AuthController>()
          ? Get.find<AuthController>().user.value?.constituencyId
          : null;

  Future<List<PostResponse>> getRecentPosts() async {
    try {
      final resp = await _dio.get('/constituencies/posts/recent');
      return _parseList(resp.data);
    } catch (e) {
      debugPrint('[PostService] getRecentPosts error: $e');
      return [];
    }
  }

  Future<List<PostResponse>> getPosts({int page = 1}) async {
    final cid = _constituencyId;
    if (cid == null) return [];
    try {
      final resp = await _dio.get(
        '/constituencies/$cid/posts',
        queryParameters: {'page': page, 'page_size': 20},
      );
      return _parseList(resp.data);
    } catch (e) {
      debugPrint('[PostService] getPosts error: $e');
      return [];
    }
  }

  Future<PostResponse?> getPost(String postId) async {
    final cid = _constituencyId;
    if (cid == null) return null;
    try {
      final resp = await _dio.get('/constituencies/$cid/posts/$postId');
      final data = _unwrap(resp.data);
      if (data == null) return null;
      return PostResponse.fromJson(data);
    } catch (e) {
      debugPrint('[PostService] getPost error: $e');
      return null;
    }
  }

  Future<void> likePost(String postId) async {
    final cid = _constituencyId;
    if (cid == null) return;
    try {
      await _dio.post('/constituencies/$cid/posts/$postId/like');
    } catch (e) {
      debugPrint('[PostService] likePost error: $e');
    }
  }

  List<PostResponse> _parseList(dynamic body) {
    if (body is! Map<String, dynamic>) return [];
    final data = body['data'];
    List? items;
    if (data is Map<String, dynamic>) {
      items = data['items'] as List? ?? (data.values.firstWhere((v) => v is List, orElse: () => null) as List?);
    } else if (data is List) {
      items = data;
    }
    if (items == null) return [];
    return items
        .whereType<Map<String, dynamic>>()
        .map((j) {
          try {
            return PostResponse.fromJson(j);
          } catch (_) {
            return null;
          }
        })
        .whereType<PostResponse>()
        .toList();
  }

  Map<String, dynamic>? _unwrap(dynamic body) {
    if (body is! Map<String, dynamic>) return null;
    final data = body['data'];
    if (data is Map<String, dynamic>) return data;
    return null;
  }
}
