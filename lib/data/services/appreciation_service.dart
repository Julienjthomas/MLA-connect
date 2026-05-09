import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/appreciation_model.dart';

class AppreciationService {
  SupabaseClient get _db => Supabase.instance.client;

  Future<List<AppreciationModel>> getMyAppreciations(String userId) async {
    final res = await _db
        .from('appreciations')
        .select('*, appreciation_media(*)')
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    return (res as List).map((j) => AppreciationModel.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<String> submit(AppreciationFormData data, String userId) async {
    final res = await _db
        .from('appreciations')
        .insert(data.toJson(userId))
        .select()
        .single();
    final id = res['id'] as String;

    if (data.mediaUrls.isNotEmpty) {
      await _db.from('appreciation_media').insert(
        data.mediaUrls.map((url) => {'appreciation_id': id, 'url': url}).toList(),
      );
    }

    return id;
  }
}
