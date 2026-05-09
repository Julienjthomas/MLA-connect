import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/improvement_model.dart';

class ImprovementService {
  SupabaseClient get _db => Supabase.instance.client;

  Future<List<ImprovementModel>> getMyImprovements(String userId) async {
    final res = await _db
        .from('improvements')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    return (res as List).map((j) => ImprovementModel.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<String> submit(ImprovementFormData data, String userId) async {
    final res = await _db
        .from('improvements')
        .insert(data.toJson(userId))
        .select()
        .single();
    return res['id'] as String;
  }
}
