import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/appreciation_model.dart';
import 'submission_utils.dart';

class AppreciationService {
  SupabaseClient get _db => Supabase.instance.client;

  Future<List<AppreciationModel>> getMyAppreciations(String userId) async {
    final res = await _db
        .from('submissions')
        .select('*, media_attachments(*)')
        .eq('kind', 'appreciation')
        .eq('reporter_id', userId)
        .order('created_at', ascending: false);
    return (res as List).map((j) => AppreciationModel.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<String> submit(AppreciationFormData data, String userId) async {
    final referenceId = SubmissionUtils.generateReferenceId('AP');
    final res = await _db
        .from('submissions')
        .insert(data.toJson(userId, referenceId))
        .select()
        .single();
    final submissionId = res['id'] as String;

    if (data.mediaUrls.isNotEmpty) {
      await _db.from('media_attachments').insert(
        data.mediaUrls
            .map((url) => {
                  'attachable_type': 'submission',
                  'attachable_id': submissionId,
                  'kind': 'image',
                  'storage_path': url,
                  'url': url,
                })
            .toList(),
      );
    }

    return submissionId;
  }
}
