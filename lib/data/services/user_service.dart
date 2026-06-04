import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../core/constants/constituency_seed.dart';
import '../models/constituency_model.dart';
import '../models/geography/local_body_response.dart';
import '../models/geography/ward_response.dart';
import '../models/profile/citizen_profile.dart';
import '../models/profile/personal_info_request.dart';
import '../models/profile/update_profile_request.dart';
import '../models/user_model.dart';
import '../remote/geography_api.dart';
import '../remote/profile_api.dart';

class UserService {
  ProfileApi get _profileApi => Get.find<ProfileApi>();
  GeographyApi get _geographyApi => Get.find<GeographyApi>();

  Future<UserModel?> getProfile(String citizenId) async {
    try {
      final profile = await _profileApi.getProfile();
      return _mapProfile(profile);
    } on Exception catch (e) {
      debugPrint('[UserService] getProfile error: $e');
      return null;
    }
  }

  Future<void> createProfile(Map<String, dynamic> data) async {
    await _profileApi.savePersonalInfo(
      PersonalInfoRequest(
        name: data['full_name'] as String?,
        phone: data['phone'] as String?,
        email: data['email'] as String?,
        language: data['language'] as String?,
        constituencyId: data['constituency_id'] as String?,
        localBodyId: data['local_body_id'] as String?,
        wardId: data['ward_id'] as String?,
        onboardedAt: data['onboarded_at'] != null
            ? DateTime.tryParse(data['onboarded_at'] as String)
            : null,
      ),
    );
  }

  Future<void> updateProfile(String citizenId, Map<String, dynamic> data) async {
    await _profileApi.updateProfile(
      UpdateProfileRequest(
        name: data['full_name'] as String?,
        email: data['email'] as String?,
        avatarUrl: data['avatar_url'] as String?,
        language: data['language'] as String?,
      ),
    );
  }

  Future<void> saveConstituencySelection({
    required String userId,
    required String constituencyId,
  }) async {
    await _profileApi.savePersonalInfo(
      PersonalInfoRequest(constituencyId: constituencyId),
    );
  }

  Future<List<ConstituencyModel>> getConstituencies() async {
    try {
      final results = await _geographyApi.getConstituencies();
      if (results.isNotEmpty) {
        return results
            .map((r) => ConstituencyModel(id: r.id, name: r.name, slug: r.slug))
            .toList();
      }
    } catch (e) {
      debugPrint('[UserService] getConstituencies error: $e');
    }
    return ConstituencySeed.constituencies
        .map((m) => ConstituencyModel(id: m['id']!, name: m['name']!, slug: m['slug']))
        .toList();
  }

  Future<List<LocalBodyModel>> getLocalBodies({String? constituencyId}) async {
    if (constituencyId != null) {
      try {
        final results = await _geographyApi.getLocalBodies(constituencyId);
        if (results.isNotEmpty) {
          return results.map(_mapLocalBody).toList();
        }
      } catch (e) {
        debugPrint('[UserService] getLocalBodies error: $e');
      }
      return _fallbackLocalBodies(constituencyId);
    }
    return [];
  }

  Future<List<WardModel>> getWards(
    String localBodyId, {
    String? constituencyId,
    String? localBodyName,
  }) async {
    if (localBodyId.startsWith('fallback-lb-')) {
      return _syntheticWards(localBodyId, constituencyId, localBodyName);
    }
    if (constituencyId != null) {
      try {
        final results = await _geographyApi.getWards(constituencyId, localBodyId);
        if (results.isNotEmpty) {
          return results.map(_mapWard).toList();
        }
      } catch (e) {
        debugPrint('[UserService] getWards error: $e');
      }
    }
    return _syntheticWards(localBodyId, constituencyId, localBodyName);
  }

  Future<void> saveNotificationPrefs(String userId, Map<String, bool> prefs) async {
    await _profileApi.updateSettings(prefs.cast<String, dynamic>());
  }

  // ── Mapping helpers ──────────────────────────────────────────────────────

  UserModel _mapProfile(CitizenProfile p) => UserModel(
        id: p.id,
        citizenRowId: p.id,
        name: p.name,
        phone: p.phone,
        email: p.email,
        avatarUrl: p.avatarUrl,
        language: p.language,
        constituencyId: p.constituencyId,
        constituencyName: p.constituencyName,
        localBodyId: p.localBodyId,
        localBodyName: p.localBodyName,
        wardId: p.wardId,
        wardName: p.wardName,
        onboardedAt: p.onboardedAt,
        wardUpdatedAt: p.wardUpdatedAt,
        contributionCount: p.contributionCount,
      );

  LocalBodyModel _mapLocalBody(LocalBodyResponse r) => LocalBodyModel(
        id: r.id,
        name: r.name,
        type: r.type,
        constituencyId: r.constituencyId,
      );

  WardModel _mapWard(WardResponse r) => WardModel(
        id: r.id,
        localBodyId: r.localBodyId,
        wardNumber: r.wardNumber,
        name: r.name ?? 'Ward ${r.wardNumber}',
      );

  // ── Seed fallbacks ────────────────────────────────────────────────────────

  List<LocalBodyModel> _fallbackLocalBodies(String constituencyRef) {
    final slug = _slugFor(constituencyRef) ?? constituencyRef;
    final names = ConstituencySeed.panchayathsByConstituency[slug] ?? const [];
    return [
      for (var i = 0; i < names.length; i++)
        LocalBodyModel(
          id: 'fallback-lb-$slug-$i',
          name: names[i],
          type: 'panchayat',
          constituencyId: constituencyRef,
        ),
    ];
  }

  List<WardModel> _syntheticWards(
    String localBodyId,
    String? constituencyRef,
    String? localBodyName,
  ) {
    final slug = constituencyRef != null ? _slugFor(constituencyRef) : null;
    final n = (slug != null && localBodyName != null)
        ? (ConstituencySeed.wardCountsByPanchayath[slug]?[localBodyName] ?? 12)
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

  String? _slugFor(String ref) {
    if (ConstituencySeed.legacyUuidToSlug.containsKey(ref)) {
      return ConstituencySeed.legacyUuidToSlug[ref];
    }
    if (ConstituencySeed.knownSlugs.contains(ref)) return ref;
    return null;
  }
}
