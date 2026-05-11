import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/report_model.dart';
import 'submission_utils.dart';

class ReportService {
  SupabaseClient get _db => Supabase.instance.client;

  static const _submissionSelect =
      '*, wards(name), media_attachments(*), submission_status_history(*)';

  Future<List<ReportModel>> getMyReports(String userId) async {
    final res = await _db
        .from('submissions')
        .select(_submissionSelect)
        .eq('kind', 'report')
        .eq('reporter_id', userId)
        .order('created_at', ascending: false);
    return (res as List).map((j) => ReportModel.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<ReportModel?> getReport(String id) async {
    final res = await _db
        .from('submissions')
        .select(_submissionSelect)
        .eq('id', id)
        .eq('kind', 'report')
        .maybeSingle();
    if (res == null) return null;
    return ReportModel.fromJson(res);
  }

  Future<String> submitReport(ReportFormData data, String userId) async {
    final referenceId = SubmissionUtils.generateReferenceId('RP');
    final res = await _db
        .from('submissions')
        .insert(data.toJson(userId, referenceId))
        .select()
        .single();
    final submissionId = res['id'] as String;

    await _db.from('submission_status_history').insert({
      'submission_id': submissionId,
      'to_status': 'submitted',
      'notes': 'Your report was received. Our team will review it shortly.',
    });

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
