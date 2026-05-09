import '../../core/constants/app_enums.dart';
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
        id: json['id'] as String,
        userId: json['user_id'] as String,
        recipientCategory: json['recipient_category'] as String? ?? '',
        staffName: json['staff_name'] as String?,
        department: json['department'] as String?,
        relatedWork: json['related_work'] as String?,
        message: json['message'] as String? ?? '',
        visibility: SubmissionVisibility.values.firstWhere(
          (v) => v.dbValue == json['visibility'],
          orElse: () => SubmissionVisibility.public,
        ),
        anonymous: json['anonymous'] as bool? ?? false,
        status: SubmissionStatusX.fromString(json['status'] as String? ?? 'submitted'),
        createdAt: DateTime.parse(json['created_at'] as String),
        mediaUrls: (json['appreciation_media'] as List?)?.map((m) => m['url'] as String).toList() ?? [],
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

  Map<String, dynamic> toJson(String userId) => {
        'user_id': userId,
        'recipient_category': recipientCategory,
        if (staffName != null && staffName!.isNotEmpty) 'staff_name': staffName,
        if (department != null && department!.isNotEmpty) 'department': department,
        if (relatedWork != null && relatedWork!.isNotEmpty) 'related_work': relatedWork,
        'message': message,
        'visibility': visibility.dbValue,
        'anonymous': anonymous,
        'status': 'submitted',
      };
}
