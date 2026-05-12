import '../../core/constants/app_enums.dart';
import '../../core/utils/json_ids.dart';
import '../../core/utils/date_formatter.dart';

class AppreciationModel {
  final String id;
  final String userId;
  final String recipientCategory;
  final String? staffName;
  final String? department;
  final String? relatedWork;
  final String message;
  final SubmissionVisibility visibility;
  final bool anonymous;
  final SubmissionStatus status;
  final DateTime createdAt;
  final List<String> mediaUrls;

  const AppreciationModel({
    required this.id,
    required this.userId,
    required this.recipientCategory,
    this.staffName,
    this.department,
    this.relatedWork,
    required this.message,
    required this.visibility,
    required this.anonymous,
    required this.status,
    required this.createdAt,
    this.mediaUrls = const [],
  });

  factory AppreciationModel.fromJson(Map<String, dynamic> json) => AppreciationModel(
        id: jsonIdToString(json['id']),
        userId: jsonIdToString(json['reporter_id']),
        recipientCategory: json['target_type'] as String? ?? '',
        staffName: json['recipient_staff_name'] as String?,
        department: json['recipient_department'] as String?,
        relatedWork: json['related_project_name'] as String?,
        message: json['description'] as String? ?? '',
        visibility: SubmissionVisibility.values.firstWhere(
          (v) => v.dbValue == json['visibility'],
          orElse: () => SubmissionVisibility.public,
        ),
        anonymous: json['is_anonymous'] as bool? ?? false,
        status: SubmissionStatusX.fromString(json['status'] as String? ?? 'submitted'),
        createdAt: DateTime.parse(json['created_at'] as String),
        mediaUrls: (json['media_attachments'] as List?)
                ?.map((m) => m['url'] as String? ?? '')
                .where((u) => u.isNotEmpty)
                .toList() ??
            [],
      );

  String get timeAgo => DateFormatter.timeAgo(createdAt);
}

class AppreciationFormData {
  final String recipientCategory;
  final String? staffName;
  final String? department;
  final String? relatedWork;
  final String message;
  final SubmissionVisibility visibility;
  final bool anonymous;
  final List<String> mediaUrls;

  const AppreciationFormData({
    required this.recipientCategory,
    this.staffName,
    this.department,
    this.relatedWork,
    required this.message,
    required this.visibility,
    this.anonymous = false,
    this.mediaUrls = const [],
  });

  Map<String, dynamic> toJson(String userId, String referenceId) => {
        'reporter_id': userId,
        'kind': 'appreciation',
        'reference_id': referenceId,
        'target_type': recipientCategory,
        if (staffName != null && staffName!.isNotEmpty) 'recipient_staff_name': staffName,
        if (department != null && department!.isNotEmpty) 'recipient_department': department,
        if (relatedWork != null && relatedWork!.isNotEmpty) 'related_project_name': relatedWork,
        'description': message,
        'title': message.length > 80 ? '${message.substring(0, 80)}...' : message,
        'visibility': visibility.dbValue,
        'is_anonymous': anonymous,
      };
}
