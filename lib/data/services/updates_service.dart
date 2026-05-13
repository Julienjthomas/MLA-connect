import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants/app_enums.dart';
import '../../features/auth/controllers/auth_controller.dart';
import '../models/update_model.dart';

class UpdatesService {
  SupabaseClient get _db => Supabase.instance.client;

  String? get _citizenRowId =>
      Get.isRegistered<AuthController>() ? Get.find<AuthController>().user.value?.citizenRowId : null;

  Future<List<UpdateModel>> getUpdates({UpdateCategory? category}) async {
    final res = await _db.from('posts').select().order('published_at', ascending: false);
    final all = (res as List).map((j) => UpdateModel.fromJson(j as Map<String, dynamic>)).toList();
    if (category == null || category == UpdateCategory.all) return all;
    return all.where((u) => u.category == category).toList();
  }

  Future<UpdateModel?> getUpdate(String id) async {
    final res = await _db.from('posts').select().eq('id', id).maybeSingle();
    if (res == null) return null;
    return UpdateModel.fromJson(res);
  }

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
}
