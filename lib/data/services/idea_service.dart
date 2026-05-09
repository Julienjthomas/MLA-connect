import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/idea_model.dart';

class IdeaService {
  SupabaseClient get _db => Supabase.instance.client;

  Future<List<IdeaModel>> getMyIdeas(String userId) async {
    final res = await _db
        .from('ideas')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    return (res as List).map((j) => IdeaModel.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<String> submit(IdeaFormData data, String userId) async {
    final res = await _db
        .from('ideas')
        .insert(data.toJson(userId))
        .select()
        .single();
    return res['id'] as String;
  }
}
