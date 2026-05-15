import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants/constituency_seed.dart';
import '../../core/utils/constituency_db_id.dart';
import '../../core/utils/json_ids.dart';
import '../models/constituency_model.dart';
import '../models/user_model.dart';

class UserService {
  SupabaseClient get _db => Supabase.instance.client;

  Future<UserModel?> getProfile(String userId) async {
    final res = await _db.from('citizens').select().eq('user_id', userId).maybeSingle();
    if (res == null) return null;
    final map = Map<String, dynamic>.from(res);

    final cidRaw = jsonIdToNullableString(map['constituency_id']);
    final cid = await ConstituencyDbId.resolve(_db, cidRaw) ??
        (cidRaw != null && ConstituencyDbId.isNumericId(cidRaw) ? cidRaw : null);
    final lbid = jsonIdToNullableString(map['local_body_id']);
    final wid = jsonIdToNullableString(map['ward_id']);

    await Future.wait([
      if (cid != null)
        _db.from('constituencies').select('name').eq('id', cid).maybeSingle().then((row) {
          if (row != null) map['constituencies'] = row;
        }),
      if (lbid != null)
        _db.from('local_bodies').select('name').eq('id', lbid).maybeSingle().then((row) {
          if (row != null) map['local_bodies'] = row;
        }),
      if (wid != null)
        _db.from('wards').select('name').eq('id', wid).maybeSingle().then((row) {
          if (row != null) map['wards'] = row;
        }),
    ]);

    return UserModel.fromJson(map);
  }

  Future<void> createProfile(Map<String, dynamic> data) async {
    await _db.from('citizens').upsert(data, onConflict: 'user_id');
  }

  Future<void> updateProfile(String userId, Map<String, dynamic> data) async {
    await _db.from('citizens').update(data).eq('user_id', userId);
  }

  /// Persists assembly constituency during onboarding (partial row OK).
  Future<void> saveConstituencySelection({
    required String userId,
    required String constituencyId,
  }) async {
    final resolved = await ConstituencyDbId.resolve(_db, constituencyId) ?? constituencyId;
    if (!ConstituencyDbId.isNumericId(resolved)) {
      if (kDebugMode) {
        debugPrint('[UserService] saveConstituencySelection: could not resolve $constituencyId to DB id');
      }
      return;
    }
    final phone = Supabase.instance.client.auth.currentUser?.phone ?? '';
    final existing = await getProfile(userId);
    if (existing == null) {
      await _db.from('citizens').insert({
        'user_id': userId,
        'phone': phone,
        'constituency_id': resolved,
        'full_name': 'Citizen',
        'language': 'en',
      });
    } else {
      await _db.from('citizens').update({'constituency_id': resolved}).eq('user_id', userId);
    }
  }

  Future<List<ConstituencyModel>> getConstituencies() async {
    try {
      final res = await _db.from('constituencies').select().order('name');
      final list = (res as List).map((j) => ConstituencyModel.fromJson(j as Map<String, dynamic>)).toList();
      if (list.length >= 3) return list;
    } catch (_) {}
    return ConstituencySeed.constituencies
        .map((m) => ConstituencyModel(id: m['id']!, name: m['name']!, slug: m['slug']))
        .toList();
  }

  Future<String?> _slugForSeedMaps(String? ref) async {
    if (ref == null) return null;
    if (ConstituencySeed.legacyUuidToSlug.containsKey(ref)) {
      return ConstituencySeed.legacyUuidToSlug[ref];
    }
    if (ConstituencySeed.knownSlugs.contains(ref)) return ref;
    if (ConstituencyDbId.isNumericId(ref)) {
      try {
        final row = await _db.from('constituencies').select('name').eq('id', ref).maybeSingle();
        final slug = ConstituencySeed.slugForConstituencyName(row?['name'] as String?);
        if (slug != null) return slug;
        // no slug column in DB — skip
      } catch (_) {}
    }
    return null;
  }

  Future<List<LocalBodyModel>> getLocalBodies({String? constituencyId}) async {
    try {
      final List<dynamic> res;
      if (constituencyId != null) {
        final dbId = await ConstituencyDbId.resolve(_db, constituencyId) ??
            (ConstituencyDbId.isNumericId(constituencyId) ? constituencyId : null);
        if (dbId != null) {
          res = await _db.from('local_bodies').select().eq('constituency_id', dbId).order('name') as List<dynamic>;
        } else {
          res = const [];
        }
      } else {
        res = await _db.from('local_bodies').select().order('name') as List<dynamic>;
      }
      final parsed = res.map((j) => LocalBodyModel.fromJson(j as Map<String, dynamic>)).toList();
      if (parsed.isNotEmpty || constituencyId == null) return parsed;
    } catch (_) {}

    if (constituencyId != null) {
      return _fallbackLocalBodies(constituencyId);
    }
    return [];
  }

  Future<List<LocalBodyModel>> _fallbackLocalBodies(String constituencyRef) async {
    final slug = await _slugForSeedMaps(constituencyRef) ?? constituencyRef;
    final names = ConstituencySeed.panchayathsByConstituency[slug] ?? const [];
    final dbCid = await ConstituencyDbId.resolve(_db, constituencyRef) ??
        (ConstituencyDbId.isNumericId(constituencyRef) ? constituencyRef : null);
    final storeId = dbCid ?? constituencyRef;
    return [
      for (var i = 0; i < names.length; i++)
        LocalBodyModel(
          id: 'fallback-lb-$slug-$i',
          name: names[i],
          type: 'panchayat',
          constituencyId: storeId,
        ),
    ];
  }

  Future<List<WardModel>> getWards(
    String localBodyId, {
    String? constituencyId,
    String? localBodyName,
  }) async {
    final seedSlug = await _slugForSeedMaps(constituencyId);
    if (localBodyId.startsWith('fallback-lb-')) {
      return _syntheticWards(localBodyId, seedSlug ?? constituencyId, localBodyName);
    }
    try {
      final res = await _db
          .from('wards')
          .select()
          .eq('local_body_id', localBodyId)
          .order('ward_number');
      final rows = (res as List).map((j) => WardModel.fromJson(j as Map<String, dynamic>)).toList();
      if (rows.isNotEmpty) return rows;
    } catch (_) {}

    if (constituencyId != null && localBodyName != null) {
      return _syntheticWards(localBodyId, seedSlug ?? constituencyId, localBodyName);
    }
    return [];
  }

  List<WardModel> _syntheticWards(String localBodyId, String? seedMapSlug, String? localBodyName) {
    final n = (seedMapSlug != null && localBodyName != null)
        ? (ConstituencySeed.wardCountsByPanchayath[seedMapSlug]?[localBodyName] ?? 12)
        : 12;
    return [
      for (var i = 0; i < n; i++)
        WardModel(
          id: 'fallback-ward-$localBodyId-${i + 1}',
          localBodyId: localBodyId,
          wardNumber: i + 1,
          name: 'Area ${i + 1}',
        ),
    ];
  }

  Future<void> saveNotificationPrefs(String userId, Map<String, bool> prefs) async {
    final profile = await getProfile(userId);
    final cid = profile?.citizenRowId;
    if (cid == null || cid.isEmpty) {
      if (kDebugMode) {
        debugPrint('[UserService] saveNotificationPrefs: no citizens row for auth user');
      }
      return;
    }
    await _db.from('notification_preferences').upsert(
      {
        'user_id': cid,
        ...prefs,
      },
      onConflict: 'user_id',
    );
  }
}
