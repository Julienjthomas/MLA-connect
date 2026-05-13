import 'package:get/get.dart';

import '../../core/utils/json_ids.dart';

class MlaModel {
  final String id;
  final String name;
  final String? photoUrl;
  final String bio;
  final String? bioMl;
  final String term;
  final String constituency;
  final String? education;
  final MlaStats stats;
  final MlaContact contact;
  final List<MlaInitiative> initiatives;

  const MlaModel({
    required this.id,
    required this.name,
    this.photoUrl,
    required this.bio,
    this.bioMl,
    required this.term,
    required this.constituency,
    this.education,
    required this.stats,
    required this.contact,
    this.initiatives = const [],
  });

  factory MlaModel.fromJson(Map<String, dynamic> json) {
    return MlaModel(
      id: jsonIdToString(json['id']),
      name: json['full_name'] as String? ?? json['name'] as String? ?? '',
      photoUrl: json['photo_url'] as String?,
      bio: json['bio'] as String? ?? '',
      bioMl: json['bio_ml'] as String?,
      term: json['term_label'] as String? ?? json['term'] as String? ?? '',
      constituency: json['constituencies']?['name'] as String? ?? json['constituency'] as String? ?? '',
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

  static MlaModel get placeholder => MlaModel(
        id: '1',
        name: 'MLA V T Sooraj',
        photoUrl: 'https://i.pravatar.cc/300?img=68',
        bio:
            'Working for the overall development of the constituency. Focused on infrastructure, education, health and environment sustainability.',
        term: '3rd Term MLA',
        constituency: 'Your Constituency',
        stats: const MlaStats(
          issuesResolved: 1248,
          activeProjects: 86,
          appreciations: 2431,
          ideasImplemented: 18,
        ),
        contact: const MlaContact(
          phone: '+91 9847 123 456',
          whatsapp: '+91 9847 123 456',
          email: 'mla@balussery.kerala.gov.in',
          officeAddress: 'MLA Office, Kozhikode, Kerala',
        ),
        initiatives: [
          MlaInitiative(
            title: 'Amrita Setu Bridge Project',
            description: 'New road connectivity for 3 panchayats',
            imageUrl: 'https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?w=400&q=80',
            progress: 0.65,
          ),
          MlaInitiative(
            title: 'Drinking Water Scheme',
            description: '₹4.2 Crore pipeline project for 5 wards',
            imageUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400&q=80',
            progress: 0.85,
          ),
          MlaInitiative(
            title: 'School Renovation Drive',
            description: '12 government schools upgraded',
            imageUrl: 'https://images.unsplash.com/photo-1580582932707-520aed937b7b?w=400&q=80',
            progress: 1.0,
          ),
        ],
      );
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

  const MlaContact({
    required this.phone,
    this.whatsapp,
    this.email,
    this.officeAddress,
  });
}

class MlaInitiative {
  final String title;
  final String description;
  final String? imageUrl;
  final double progress;

  const MlaInitiative({
    required this.title,
    required this.description,
    this.imageUrl,
    required this.progress,
  });
}
