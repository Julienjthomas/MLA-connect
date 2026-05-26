import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/utils/json_ids.dart';
import '../models/appreciation_model.dart';
import 'submission_media_merger.dart';
import 'submission_utils.dart';

class AppreciationService {
  SupabaseClient get _db => Supabase.instance.client;

  Future<List<AppreciationModel>> getMyAppreciations() async {
    final uid = SubmissionUtils.currentAuthUserId(_db);
    if (uid == null) return const [];
    final res = await _db
        .from('submissions')
        .select('*, $kMySubmissionsCitizenEmbed')
        .eq('kind', 'appreciation')
        .eq('citizens.user_id', uid)
        .order('created_at', ascending: false);
    final rows =
        (res as List).map((j) => Map<String, dynamic>.from(j as Map<String, dynamic>)).toList();
    await SubmissionMediaMerger.attachForSubmissions(_db, rows);
    return rows.map(AppreciationModel.fromJson).toList();
  }

  Future<String> submit(AppreciationFormData data, String userId) async {
    final referenceId = SubmissionUtils.generateReferenceId('AP');
    final res = await _db
        .from('submissions')
        .insert(data.toJson(userId, referenceId))
        .select()
        .single();
    final submissionId = jsonIdToString(res['id']);

    if (data.mediaUrls.isNotEmpty) {
      await _db.from('media_attachments').insert(
        data.mediaUrls
            .map((url) => {
                  'attachable_type': 'submission',
                  'attachable_id': submissionId,
                  'kind': 'image',
                  'storage_path': url,
                  'url': url,
                  'uploaded_by': userId,
                  'uploaded_by_type': 'citizen',
                })
            .toList(),
      );
    }

    return submissionId;
  }
}
