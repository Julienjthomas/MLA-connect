import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants/app_enums.dart';
import '../models/update_model.dart';

class UpdatesService {
  SupabaseClient get _db => Supabase.instance.client;

  Future<List<UpdateModel>> getUpdates({UpdateCategory? category}) async {
    var query = _db.from('updates').select().order('created_at', ascending: false);
    final res = await query;
    final all = (res as List).map((j) => UpdateModel.fromJson(j as Map<String, dynamic>)).toList();
    if (category == null || category == UpdateCategory.all) return all;
    return all.where((u) => u.category == category).toList();
  }

  Future<UpdateModel?> getUpdate(String id) async {
    final res = await _db.from('updates').select().eq('id', id).maybeSingle();
    if (res == null) return null;
    return UpdateModel.fromJson(res);
  }

  Future<void> likeUpdate(String id) async {
    await _db.rpc('increment_likes', params: {'row_id': id});
  }
}
