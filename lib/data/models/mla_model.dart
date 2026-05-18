import 'package:get/get.dart';

import '../../core/utils/json_ids.dart';

class MlaModel {
  final String id;
  final String name;
  final String? photoUrl;
  final String? coverImageUrl;
  final String bio;
  final String? bioMl;
  final String term;
  final String constituency;
  final String? education;
  final List<String> galleryUrls;
  final MlaStats stats;
  final MlaContact contact;
  final List<MlaInitiative> initiatives;

  const MlaModel({
    required this.id,
    required this.name,
    this.photoUrl,
    this.coverImageUrl,
    required this.bio,
    this.bioMl,
    required this.term,
    required this.constituency,
    this.education,
    this.galleryUrls = const [],
    required this.stats,
    required this.contact,
    this.initiatives = const [],
  });

  factory MlaModel.fromJson(Map<String, dynamic> json) {
    final rawGallery = json['gallery_urls'];
    final gallery = <String>[
      if (rawGallery is List)
        for (final v in rawGallery)
          if (v is String && v.isNotEmpty) v,
    ];
    return MlaModel(
      id: jsonIdToString(json['id']),
      name: json['full_name'] as String? ?? json['name'] as String? ?? '',
      photoUrl: json['photo_url'] as String?,
      coverImageUrl: json['cover_image_url'] as String?,
      bio: json['bio'] as String? ?? '',
      bioMl: json['bio_ml'] as String?,
      term: json['term_label'] as String? ?? json['term'] as String? ?? '',
      constituency: json['constituencies']?['name'] as String? ?? json['constituency'] as String? ?? '',
      galleryUrls: gallery,
      stats: MlaStats(
        issuesResolved: json['issues_resolved'] as int? ?? 0,
        activeProjects: json['active_projects'] as int? ?? 0,
        appreciations: json['appreciations_count'] as int? ?? 0,
        ideasImplemented: json['ideas_implemented'] as int? ?? 0,
      ),
      contact: MlaContact(
        phone: json['office_phone'] as String? ?? '',
        whatsapp: json['office_phone'] as String?,
        email: json['office_email'] as String?,
        officeAddress: json['office_address'] as String?,
      ),
    );
  }

  String get localBio {
    final isMl = Get.locale?.languageCode == 'ml';
    return (isMl && bioMl != null && bioMl!.isNotEmpty) ? bioMl! : bio;
  }
}

class MlaStats {
  final int issuesResolved;
  final int activeProjects;
  final int appreciations;
  final int ideasImplemented;

  const MlaStats({
    required this.issuesResolved,
    required this.activeProjects,
    required this.appreciations,
    required this.ideasImplemented,
  });
}

class MlaContact {
  final String phone;
  final String? whatsapp;
  final String? email;
  final String? officeAddress;

  const MlaContact({required this.phone, this.whatsapp, this.email, this.officeAddress});
}

class MlaInitiative {
  final String title;
  final String description;
  final String? imageUrl;
  final double progress;

  const MlaInitiative({required this.title, required this.description, this.imageUrl, required this.progress});
}
