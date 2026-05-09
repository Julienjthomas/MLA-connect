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
  final String? estimatedResources;
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
    this.estimatedResources,
    required this.visibility,
    required this.allowDiscussion,
    required this.allowContact,
    required this.status,
    required this.createdAt,
  });

  factory IdeaModel.fromJson(Map<String, dynamic> json) => IdeaModel(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        topic: json['topic'] as String? ?? '',
        title: json['title'] as String? ?? '',
        description: json['description'] as String? ?? '',
        benefits: json['benefits'] as String?,
        beneficiaries: (json['beneficiaries'] as List?)?.cast<String>() ?? [],
        estimatedResources: json['estimated_resources'] as String?,
        visibility: SubmissionVisibility.values.firstWhere(
          (v) => v.dbValue == json['visibility'],
          orElse: () => SubmissionVisibility.public,
        ),
        allowDiscussion: json['allow_discussion'] as bool? ?? true,
        allowContact: json['allow_contact'] as bool? ?? true,
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
  final String? estimatedResources;
  final SubmissionVisibility visibility;
  final bool allowDiscussion;
  final bool allowContact;

  const IdeaFormData({
    required this.topic,
    required this.title,
    required this.description,
    this.benefits,
    this.beneficiaries = const [],
    this.estimatedResources,
    required this.visibility,
    required this.allowDiscussion,
    required this.allowContact,
  });

  Map<String, dynamic> toJson(String userId) => {
        'user_id': userId,
        'topic': topic,
        'title': title,
        'description': description,
        if (benefits != null && benefits!.isNotEmpty) 'benefits': benefits,
        'beneficiaries': beneficiaries,
        if (estimatedResources != null && estimatedResources!.isNotEmpty) 'estimated_resources': estimatedResources,
        'visibility': visibility.dbValue,
        'allow_discussion': allowDiscussion,
        'allow_contact': allowContact,
        'status': 'submitted',
      };
}
