import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

class UserService {
  SupabaseClient get _db => Supabase.instance.client;

  Future<UserModel?> getProfile(String userId) async {
    final res = await _db
        .from('citizens')
        .select('*, local_bodies(name), wards(name)')
        .eq('user_id', userId)
        .maybeSingle();
    if (res == null) return null;
    return UserModel.fromJson(res);
  }

  Future<void> createProfile(Map<String, dynamic> data) async {
    await _db.from('citizens').upsert(data);
  }

  Future<void> updateProfile(String userId, Map<String, dynamic> data) async {
    await _db.from('citizens').update(data).eq('user_id', userId);
  }

  Future<List<LocalBodyModel>> getLocalBodies() async {
    final res = await _db.from('local_bodies').select().order('name');
    return (res as List).map((j) => LocalBodyModel.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<List<WardModel>> getWards(String localBodyId) async {
    final res = await _db
        .from('wards')
        .select()
        .eq('local_body_id', localBodyId)
        .order('ward_number');
    return (res as List).map((j) => WardModel.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<void> saveNotificationPrefs(String userId, Map<String, bool> prefs) async {
    await _db.from('notification_preferences').upsert({
      'user_id': userId,
      ...prefs,
    });
  }
}
