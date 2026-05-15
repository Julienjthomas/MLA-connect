import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants/app_enums.dart';
import '../../core/utils/json_ids.dart';
import '../../features/auth/controllers/auth_controller.dart';
import '../models/update_model.dart';
import '../utils/supabase_storage_url.dart';

class UpdatesService {
  SupabaseClient get _db => Supabase.instance.client;

  String? get _citizenRowId =>
      Get.isRegistered<AuthController>() ? Get.find<AuthController>().user.value?.citizenRowId : null;

  Future<List<UpdateModel>> getUpdates({UpdateCategory? category}) async {
    final res = await _db.from('posts').select().order('published_at', ascending: false);
    final rows = (res as List).map((j) => Map<String, dynamic>.from(j as Map)).toList();

    if (rows.isNotEmpty) {
      await Future.wait([
        _attachPostMedia(rows),
        _signCoverImages(rows),
      ]);
      await _signAttachmentPaths(rows);
    }

    final all = rows.map(UpdateModel.fromJson).toList();
    if (category == null || category == UpdateCategory.all) return all;
    return all.where((u) => u.category == category).toList();
  }

  Future<UpdateModel?> getUpdate(String id) async {
    final res = await _db.from('posts').select().eq('id', id).maybeSingle();
    if (res == null) return null;
    final row = Map<String, dynamic>.from(res);
    await Future.wait([
      _attachPostMedia([row]),
      _signCoverImages([row]),
    ]);
    await _signAttachmentPaths([row]);
    return UpdateModel.fromJson(row);
  }

  // ── media_attachments ────────────────────────────────────────────────────

  static const _postAttachableTypes = ['post', 'Post', 'posts', 'Posts'];

  Future<void> _attachPostMedia(List<Map<String, dynamic>> rows) async {
    if (rows.isEmpty) return;
    final ids = rows.map((r) => jsonIdToString(r['id'])).where((id) => id.isNotEmpty).toList();
    if (ids.isEmpty) return;

    try {
      final res = await _db
          .from('media_attachments')
          .select('id, kind, storage_path, url, mime_type, position, attachable_id')
          .inFilter('attachable_type', _postAttachableTypes)
          .inFilter('attachable_id', ids)
          .order('position');

      final byPost = <String, List<Map<String, dynamic>>>{};
      for (final raw in res as List) {
        final m = Map<String, dynamic>.from(raw as Map);
        final aid = jsonIdToString(m['attachable_id']);
        byPost.putIfAbsent(aid, () => []).add(m);
      }
      for (final row in rows) {
        final id = jsonIdToString(row['id']);
        row['media_attachments'] = byPost[id] ?? <Map<String, dynamic>>[];
      }
    } catch (_) {
      // non-critical — posts still render without gallery
    }
  }

  // ── URL signing ──────────────────────────────────────────────────────────

  Future<void> _signCoverImages(List<Map<String, dynamic>> rows) async {
    final Map<String, List<({int idx, String path})>> byBucket = {};
    for (var i = 0; i < rows.length; i++) {
      final url = rows[i]['cover_image_url'] as String?;
      final parsed = parseSupabasePublicObjectUrl(url);
      if (parsed == null) continue;
      byBucket.putIfAbsent(parsed.bucket, () => []).add((idx: i, path: parsed.objectPath));
    }

    for (final entry in byBucket.entries) {
      final paths = entry.value.map((e) => e.path).toList();
      try {
        final signed = await _db.storage.from(entry.key).createSignedUrls(paths, 3600);
        for (var j = 0; j < entry.value.length; j++) {
          final su = j < signed.length ? signed[j].signedUrl : null;
          if (su != null && su.isNotEmpty) {
            rows[entry.value[j].idx]['cover_image_url'] = su;
          }
        }
      } catch (_) {
        // keep original public URL on failure
      }
    }
  }

  Future<void> _signAttachmentPaths(List<Map<String, dynamic>> rows) async {
    // Collect all storage_path refs grouped by bucket
    final Map<String, List<({Map<String, dynamic> attachment, String path})>> byBucket = {};

    for (final row in rows) {
      final attachments = row['media_attachments'] as List? ?? [];
      for (final raw in attachments) {
        final m = raw as Map<String, dynamic>;
        final url = m['url'] as String?;
        if (url != null && url.trim().isNotEmpty) continue; // url takes precedence
        final sp = m['storage_path'] as String?;
        final parsed = parseBucketAndPathFromStoragePath(sp);
        if (parsed == null) continue;
        byBucket.putIfAbsent(parsed.bucket, () => []).add((attachment: m, path: parsed.objectPath));
      }
    }

    for (final entry in byBucket.entries) {
      final paths = entry.value.map((e) => e.path).toList();
      try {
        final signed = await _db.storage.from(entry.key).createSignedUrls(paths, 3600);
        for (var j = 0; j < entry.value.length; j++) {
          final su = j < signed.length ? signed[j].signedUrl : null;
          if (su != null && su.isNotEmpty) {
            entry.value[j].attachment['_signed_url'] = su;
          }
        }
      } catch (_) {}
    }
  }

  // ── likes ────────────────────────────────────────────────────────────────

  Future<void> likeUpdate(String id) async {
    final cid = _citizenRowId;
    if (cid == null || cid.isEmpty) return;
    await _db.from('likes').upsert(
      {'user_id': cid, 'target_type': 'post', 'target_id': id},
      onConflict: 'user_id,target_type,target_id',
    );
  }

  Future<void> unlikeUpdate(String id) async {
    final cid = _citizenRowId;
    if (cid == null || cid.isEmpty) return;
    await _db
        .from('likes')
        .delete()
        .eq('user_id', cid)
        .eq('target_type', 'post')
        .eq('target_id', id);
  }

  Future<Set<String>> getLikedPostIds(Iterable<String> postIds) async {
    final cid = _citizenRowId;
    if (cid == null || cid.isEmpty || postIds.isEmpty) return {};
    final ids = postIds.toList();
    final res = await _db
        .from('likes')
        .select('target_id')
        .eq('user_id', cid)
        .eq('target_type', 'post')
        .inFilter('target_id', ids);
    return (res as List)
        .map((row) => row['target_id']?.toString() ?? '')
        .where((id) => id.isNotEmpty)
        .toSet();
  }
}
