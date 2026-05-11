import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/idea_model.dart';
import 'submission_utils.dart';

class IdeaService {
  SupabaseClient get _db => Supabase.instance.client;

  Future<List<IdeaModel>> getMyIdeas(String userId) async {
    final res = await _db
        .from('submissions')
        .select()
        .eq('kind', 'idea')
        .eq('reporter_id', userId)
        .order('created_at', ascending: false);
    return (res as List).map((j) => IdeaModel.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<String> submit(IdeaFormData data, String userId) async {
    final referenceId = SubmissionUtils.generateReferenceId('ID');
    final res = await _db
        .from('submissions')
        .insert(data.toJson(userId, referenceId))
        .select()
        .single();
    return res['id'] as String;
  }
}
