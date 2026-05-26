import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';
import '../../core/utils/constituency_db_id.dart';
import '../../features/auth/controllers/auth_controller.dart';
import '../models/event_model.dart';

class EventService {
  SupabaseClient get _db => Supabase.instance.client;

  String? get _constituencyId =>
      Get.isRegistered<AuthController>() ? Get.find<AuthController>().user.value?.constituencyId : null;

  Future<List<EventModel>> getEvents({int limit = 50, String? constituencyId}) async {
    final rawCid = constituencyId ?? _constituencyId;
    final dbCid = rawCid == null
        ? null
        : await ConstituencyDbId.resolve(_db, rawCid) ??
            (ConstituencyDbId.isNumericId(rawCid) ? rawCid : null);

    var q = _db.from('events').select();
    if (dbCid != null) {
      q = q.eq('constituency_id', dbCid);
    }

    final res = await q.order('starts_at', ascending: false).limit(limit);
    return (res as List)
        .map((j) => EventModel.fromJson(Map<String, dynamic>.from(j as Map)))
        .toList();
  }

  Future<List<EventModel>> getUpcoming({int limit = 5, String? constituencyId}) async {
    final now = DateTime.now().toUtc().toIso8601String();
    final rawCid = constituencyId ?? _constituencyId;
    final dbCid = rawCid == null
        ? null
        : await ConstituencyDbId.resolve(_db, rawCid) ??
            (ConstituencyDbId.isNumericId(rawCid) ? rawCid : null);

    var q = _db.from('events').select().gte('starts_at', now);
    if (dbCid != null) {
      q = q.eq('constituency_id', dbCid);
    }

    final res = await q.order('starts_at', ascending: true).limit(limit);
    return (res as List)
        .map((j) => EventModel.fromJson(Map<String, dynamic>.from(j as Map)))
        .toList();
  }
}
