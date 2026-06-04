import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../models/mla_model.dart';
import '../remote/mla_api.dart';

// Keep MlaStaffModel for backwards compat with AppreciationController
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
}

class MlaService {
  MlaApi get _api => Get.find<MlaApi>();

  /// Staff endpoint not in contract — returns empty list until backend adds it.
  Future<List<MlaStaffModel>> getPublicStaff() async => [];

  Future<MlaModel?> getMlaProfile({String? constituencyId}) async {
    if (constituencyId == null) return null;
    try {
      final r = await _api.getMla(constituencyId);
      return MlaModel(
        id: r.id,
        name: r.name,
        photoUrl: r.photoUrl,
        coverImageUrl: r.coverImageUrl,
        bio: r.bio,
        bioMl: r.bioMl,
        term: r.term,
        constituency: r.constituency,
        education: r.education,
        galleryUrls: r.galleryUrls,
        stats: MlaStats(
          issuesResolved: r.stats?.issuesResolved ?? 0,
          activeProjects: r.stats?.activeProjects ?? 0,
          appreciations: r.stats?.appreciations ?? 0,
          ideasImplemented: r.stats?.ideasImplemented ?? 0,
        ),
        contact: MlaContact(
          phone: r.contact?.phone ?? '',
          whatsapp: r.contact?.whatsapp,
          email: r.contact?.email,
          officeAddress: r.contact?.officeAddress,
        ),
        initiatives: r.initiatives
            .map((i) => MlaInitiative(title: i.title, description: i.description, progress: 0))
            .toList(),
      );
    } catch (e) {
      debugPrint('[MlaService] getMlaProfile error: $e');
      return null;
    }
  }
}
