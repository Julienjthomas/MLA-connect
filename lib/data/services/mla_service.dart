import 'package:supabase_flutter/supabase_flutter.dart';
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
        id: json['id'] as String,
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

  Future<MlaModel> getMlaProfile() async {
    try {
      final mlaRow = await _db
          .from('mlas')
          .select()
          .eq('is_current', true)
          .limit(1)
          .single();

      final mlaId = mlaRow['id'] as String;

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
