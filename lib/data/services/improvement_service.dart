import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/utils/json_ids.dart';
import '../models/improvement_model.dart';
import 'submission_media_merger.dart';
import 'submission_utils.dart';

class ImprovementService {
  SupabaseClient get _db => Supabase.instance.client;

  /// [reporterId] is the value stored on `submissions.reporter_id`.
  /// In the current schema that's `citizens.id` (bigint); use [AuthController.submissionReporterId].
  Future<List<ImprovementModel>> getMyImprovements({required String reporterId}) async {
    final rid = reporterId.trim();
    if (rid.isEmpty) return const [];
    final res = await _db
        .from('submissions')
        .select('*')
        .eq('kind', 'suggestion')
        .eq('reporter_id', rid)
        .order('created_at', ascending: false);
    final rows =
        (res as List).map((j) => Map<String, dynamic>.from(j as Map<String, dynamic>)).toList();
    await SubmissionMediaMerger.attachForSubmissions(_db, rows);
    return rows.map(ImprovementModel.fromJson).toList();
  }

  Future<String> submit(ImprovementFormData data, String reporterId) async {
    final referenceId = SubmissionUtils.generateReferenceId('SG');
    final res = await _db
        .from('submissions')
        .insert(data.toJson(reporterId, referenceId))
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
                  'uploaded_by': reporterId,
                  'uploaded_by_type': 'citizen',
                })
            .toList(),
      );
    }

    return submissionId;
  }
}
