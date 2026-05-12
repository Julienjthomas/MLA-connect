import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/utils/constituency_db_id.dart';
import '../../core/utils/json_ids.dart';
import '../models/mla_model.dart';

class MlaStaffModel {
  final String id;
  final String fullName;
  final String? designation;
  final String? photoUrl;
  final String phone;
  final String? email;
  final String? officeAddress;
  final int position;

  const MlaStaffModel({
    required this.id,
    required this.fullName,
    this.designation,
    this.photoUrl,
    required this.phone,
    this.email,
    this.officeAddress,
    required this.position,
  });

  factory MlaStaffModel.fromJson(Map<String, dynamic> json) => MlaStaffModel(
        id: jsonIdToString(json['id']),
        fullName: json['full_name'] as String? ?? '',
        designation: json['designation'] as String?,
        photoUrl: json['photo_url'] as String?,
        phone: json['phone'] as String? ?? '',
        email: json['email'] as String?,
        officeAddress: json['office_address'] as String?,
        position: json['position'] as int? ?? 0,
      );
}

class MlaService {
  SupabaseClient get _db => Supabase.instance.client;

  Future<MlaModel> getMlaProfile({String? constituencyId}) async {
    try {
      Map<String, dynamic>? mlaRow;
      if (constituencyId != null) {
        final dbCid = await ConstituencyDbId.resolve(_db, constituencyId) ??
            (ConstituencyDbId.isNumericId(constituencyId) ? constituencyId : null);
        if (dbCid != null) {
          final r = await _db
              .from('mlas')
              .select('*, constituencies(name)')
              .eq('is_current', true)
              .eq('constituency_id', dbCid)
              .maybeSingle();
          if (r != null) mlaRow = Map<String, dynamic>.from(r);
        }
      }
      mlaRow ??= await _fetchAnyCurrentMla();

      if (mlaRow == null) return MlaModel.placeholder;

      final mlaId = jsonIdToString(mlaRow['id']);

      final statsRow = await _db
          .from('v_mla_stats')
          .select()
          .eq('mla_id', mlaId)
          .maybeSingle();

      final merged = {
        ...mlaRow,
        if (statsRow != null) ...statsRow,
      };

      return MlaModel.fromJson(merged);
    } catch (_) {
      return MlaModel.placeholder;
    }
  }

  Future<Map<String, dynamic>?> _fetchAnyCurrentMla() async {
    final r = await _db.from('mlas').select('*, constituencies(name)').eq('is_current', true).limit(1).maybeSingle();
    if (r == null) return null;
    return Map<String, dynamic>.from(r);
  }

  Future<List<MlaStaffModel>> getPublicStaff() async {
    final res = await _db
        .from('mla_staff')
        .select()
        .eq('is_public', true)
        .eq('is_active', true)
        .order('position');
    return (res as List).map((j) => MlaStaffModel.fromJson(j as Map<String, dynamic>)).toList();
  }
}
