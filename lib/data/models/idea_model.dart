import '../../core/constants/app_enums.dart';
import '../../core/utils/date_formatter.dart';

class IdeaModel {
  final String id;
  final String userId;
  final String topic;
  final String title;
  final String description;
  final String? benefits;
  final List<String> beneficiaries;
  final SubmissionVisibility visibility;
  final bool allowDiscussion;
  final bool allowContact;
  final SubmissionStatus status;
  final DateTime createdAt;

  const IdeaModel({
    required this.id,
    required this.userId,
    required this.topic,
    required this.title,
    required this.description,
    this.benefits,
    this.beneficiaries = const [],
    required this.visibility,
    required this.allowDiscussion,
    required this.allowContact,
    required this.status,
    required this.createdAt,
  });

  factory IdeaModel.fromJson(Map<String, dynamic> json) => IdeaModel(
        id: json['id'] as String,
        userId: json['reporter_id'] as String,
        topic: json['topic'] as String? ?? '',
        title: json['title'] as String? ?? '',
        description: json['description'] as String? ?? '',
        benefits: json['benefits'] as String?,
        beneficiaries: (json['beneficiaries'] as List?)?.cast<String>() ?? [],
        visibility: SubmissionVisibility.values.firstWhere(
          (v) => v.dbValue == json['visibility'],
          orElse: () => SubmissionVisibility.public,
        ),
        allowDiscussion: json['allow_community_discussion'] as bool? ?? true,
        allowContact: json['allow_mla_office_contact'] as bool? ?? true,
        status: SubmissionStatusX.fromString(json['status'] as String? ?? 'submitted'),
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  String get timeAgo => DateFormatter.timeAgo(createdAt);
}

class IdeaFormData {
  final String topic;
  final String title;
  final String description;
  final String? benefits;
  final List<String> beneficiaries;
  final SubmissionVisibility visibility;
  final bool allowDiscussion;
  final bool allowContact;

  const IdeaFormData({
    required this.topic,
    required this.title,
    required this.description,
    this.benefits,
    this.beneficiaries = const [],
    required this.visibility,
    required this.allowDiscussion,
    required this.allowContact,
  });

  Map<String, dynamic> toJson(String userId, String referenceId) => {
        'reporter_id': userId,
        'kind': 'idea',
        'reference_id': referenceId,
        'topic': topic,
        'title': title,
        'description': description,
        if (benefits != null && benefits!.isNotEmpty) 'benefits': benefits,
        'beneficiaries': beneficiaries,
        'visibility': visibility.dbValue,
        'allow_community_discussion': allowDiscussion,
        'allow_mla_office_contact': allowContact,
      };
}
