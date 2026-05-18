import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/utils/json_ids.dart';
import '../models/report_model.dart';
import 'submission_media_merger.dart';
import 'submission_utils.dart';

class ReportService {
  SupabaseClient get _db => Supabase.instance.client;

  static const _submissionSelect =
      '*, wards(name), submission_status_history(*)';

  /// [reporterId] is the value stored on `submissions.reporter_id`.
  /// In the current schema that's `citizens.id` (bigint); use [AuthController.submissionReporterId].
  Future<List<ReportModel>> getMyReports({required String reporterId}) async {
    final rid = reporterId.trim();
    if (rid.isEmpty) return const [];
    final res = await _db
        .from('submissions')
        .select(_submissionSelect)
        .eq('kind', 'report')
        .eq('reporter_id', rid)
        .order('created_at', ascending: false);
    final rows =
        (res as List).map((j) => Map<String, dynamic>.from(j as Map<String, dynamic>)).toList();
    await SubmissionMediaMerger.attachForSubmissions(_db, rows);
    return rows.map(ReportModel.fromJson).toList();
  }

  Future<ReportModel?> getReport(String id) async {
    final res = await _db
        .from('submissions')
        .select(_submissionSelect)
        .eq('id', id)
        .eq('kind', 'report')
        .maybeSingle();
    if (res == null) return null;
    final map = Map<String, dynamic>.from(res);
    await SubmissionMediaMerger.attachForSubmissions(_db, [map]);
    return ReportModel.fromJson(map);
  }

  /// Returns the generated `reference_id` (UUID v4) for the new report row.
  Future<String> submitReport(ReportFormData data, String userId) async {
    final referenceId = SubmissionUtils.generateReferenceId();
    final res = await _db
        .from('submissions')
        .insert(data.toJson(userId, referenceId))
        .select()
        .single();
    final submissionId = jsonIdToString(res['id']);

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
                  'uploaded_by': userId,
                  'uploaded_by_type': 'citizen',
                })
            .toList(),
      );
    }

    // Surface the reference_id (UUID v4) to the UI for display & copy.
    // submissionId is intentionally unused by the caller; the row exists in DB.
    return referenceId;
  }
}
