import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/utils/json_ids.dart';

/// Loads `media_attachments` for submission rows.
///
/// PostgREST cannot embed `media_attachments` on `submissions` because the link
/// is polymorphic (`attachable_type` + `attachable_id`) with no FK to `submissions`.
class SubmissionMediaMerger {
  SubmissionMediaMerger._();

  static Future<void> attachForSubmissions(
    SupabaseClient db,
    List<Map<String, dynamic>> submissionRows,
  ) async {
    if (submissionRows.isEmpty) return;
    final ids = <String>[];
    for (final r in submissionRows) {
      final id = jsonIdToString(r['id']);
      if (id.isNotEmpty) ids.add(id);
    }
    if (ids.isEmpty) return;

    List<dynamic> list;
    try {
      final res = await db
          .from('media_attachments')
          .select()
          .eq('attachable_type', 'submission')
          .inFilter('attachable_id', ids);
      list = res as List<dynamic>? ?? const [];
    } catch (_) {
      for (final row in submissionRows) {
        row['media_attachments'] = <Map<String, dynamic>>[];
      }
      return;
    }
    final bySubmission = <String, List<Map<String, dynamic>>>{};
    for (final raw in list) {
      final m = Map<String, dynamic>.from(raw as Map<String, dynamic>);
      final aid = jsonIdToString(m['attachable_id']);
      bySubmission.putIfAbsent(aid, () => []).add(m);
    }
    for (final row in submissionRows) {
      final id = jsonIdToString(row['id']);
      row['media_attachments'] = bySubmission[id] ?? <Map<String, dynamic>>[];
    }
  }
}
