import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

class UserService {
  SupabaseClient get _db => Supabase.instance.client;

  Future<UserModel?> getProfile(String userId) async {
    final res = await _db
        .from('user_profiles')
        .select('*, panchayats(name), wards(name)')
        .eq('id', userId)
        .maybeSingle();
    if (res == null) return null;
    return UserModel.fromJson(res);
  }

  Future<void> createProfile(Map<String, dynamic> data) async {
    await _db.from('user_profiles').upsert(data);
  }

  Future<void> updateProfile(String userId, Map<String, dynamic> data) async {
    await _db.from('user_profiles').update(data).eq('id', userId);
  }

  Future<List<PanchayatModel>> getPanchayats() async {
    final res = await _db.from('panchayats').select().order('name');
    return (res as List).map((j) => PanchayatModel.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<List<WardModel>> getWards(String panchayatId) async {
    final res = await _db
        .from('wards')
        .select()
        .eq('panchayat_id', panchayatId)
        .order('number');
    return (res as List).map((j) => WardModel.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<void> saveNotificationPrefs(String userId, Map<String, bool> prefs) async {
    await _db.from('notification_prefs').upsert({
      'user_id': userId,
      ...prefs,
    });
  }
}
