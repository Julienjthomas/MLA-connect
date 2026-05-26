import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/utils/constituency_db_id.dart';
import '../models/public_board_item.dart';
import 'submission_media_merger.dart';

class PublicBoardService {
  SupabaseClient get _db => Supabase.instance.client;

  Future<List<PublicBoardItem>> getPublicBoard({required String constituencyId}) async {
    final resolved = await ConstituencyDbId.resolve(_db, constituencyId) ?? constituencyId;
    final cid = int.tryParse(resolved);
    if (cid == null) return [];

    final res = await _db
        .from('submissions')
        .select('*, wards(name), citizens!inner(constituency_id)')
        .eq('visibility', 'public')
        .eq('citizens.constituency_id', cid)
        .order('created_at', ascending: false)
        .limit(50);

    final rows = (res as List)
        .map((j) => Map<String, dynamic>.from(j as Map))
        .toList();

    await SubmissionMediaMerger.attachForSubmissions(_db, rows);

    return rows.map(PublicBoardItem.fromJson).toList();
  }
}
