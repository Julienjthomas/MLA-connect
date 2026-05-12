import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/utils/constituency_db_id.dart';
import '../models/office_message_model.dart';

class OfficeMessagesService {
  SupabaseClient get _db => Supabase.instance.client;

  Future<List<OfficeMessageModel>> listForUser({
    required String userId,
    String? constituencyId,
    int limit = 50,
  }) async {
    try {
      final List<dynamic> res;
      if (constituencyId != null) {
        final dbCid = await ConstituencyDbId.resolve(_db, constituencyId) ??
            (ConstituencyDbId.isNumericId(constituencyId) ? constituencyId : null);
        if (dbCid == null) {
          res = const [];
        } else {
          res = await _db
              .from('office_messages')
              .select()
              .eq('user_id', userId)
              .eq('constituency_id', dbCid)
              .order('created_at', ascending: false)
              .limit(limit) as List<dynamic>;
        }
      } else {
        res = await _db
            .from('office_messages')
            .select()
            .eq('user_id', userId)
            .order('created_at', ascending: false)
            .limit(limit) as List<dynamic>;
      }
      return res.map((j) => OfficeMessageModel.fromJson(j as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> send({
    required String userId,
    required String constituencyId,
    required String category,
    required String body,
  }) async {
    final dbCid = await ConstituencyDbId.resolve(_db, constituencyId) ??
        (ConstituencyDbId.isNumericId(constituencyId) ? constituencyId : null);
    if (dbCid == null) return;
    await _db.from('office_messages').insert({
      'user_id': userId,
      'constituency_id': dbCid,
      'category': category,
      'body': body,
    });
  }
}
