import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/report_model.dart';

class ReportService {
  SupabaseClient get _db => Supabase.instance.client;

  Future<List<ReportModel>> getMyReports(String userId) async {
    final res = await _db
        .from('reports')
        .select('*, wards(name), report_media(*), report_timeline(*)')
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    return (res as List).map((j) => ReportModel.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<ReportModel?> getReport(String id) async {
    final res = await _db
        .from('reports')
        .select('*, wards(name), report_media(*), report_timeline(*)')
        .eq('id', id)
        .maybeSingle();
    if (res == null) return null;
    return ReportModel.fromJson(res);
  }

  Future<String> submitReport(ReportFormData data, String userId) async {
    final res = await _db
        .from('reports')
        .insert(data.toJson(userId))
        .select()
        .single();
    final reportId = res['id'] as String;

    // Insert initial timeline entry
    await _db.from('report_timeline').insert({
      'report_id': reportId,
      'status': 'submitted',
      'note': 'Your report was received. Our team will review it shortly.',
    });

    // Insert media URLs
    if (data.mediaUrls.isNotEmpty) {
      await _db.from('report_media').insert(
        data.mediaUrls.map((url) => {'report_id': reportId, 'url': url, 'type': 'image'}).toList(),
      );
    }

    return reportId;
  }
}
