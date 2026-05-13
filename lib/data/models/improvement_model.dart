import '../../core/constants/app_enums.dart';
import '../../core/utils/json_ids.dart';
import '../../core/utils/date_formatter.dart';
import '../utils/submission_media_refs.dart';

class ImprovementModel {
  final String id;
  final String userId;
  final String title;
  final String suggestion;
  final String? department;
  final String? location;
  final String? landmark;
  final SubmissionStatus status;
  final DateTime createdAt;
  final List<String> mediaUrls;

  const ImprovementModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.suggestion,
    this.department,
    this.location,
    this.landmark,
    required this.status,
    required this.createdAt,
    this.mediaUrls = const [],
  });

  factory ImprovementModel.fromJson(Map<String, dynamic> json) => ImprovementModel(
        id: jsonIdToString(json['id']),
        userId: jsonIdToString(json['reporter_id']),
        title: json['title'] as String? ?? '',
        suggestion: json['description'] as String? ?? '',
        department: (json['category'] as String?) ?? (json['assigned_department'] as String?),
        location: json['pin_address'] as String?,
        landmark: json['landmark'] as String?,
        status: SubmissionStatusX.fromString(json['status'] as String? ?? 'submitted'),
        createdAt: DateTime.parse(json['created_at'] as String),
        mediaUrls: submissionMediaRefsFromJson(json),
      );

  String get timeAgo => DateFormatter.timeAgo(createdAt);
}

class ImprovementFormData {
  final String suggestion;
  final String? department;
  final String? location;
  final String? landmark;
  final List<String> mediaUrls;

  const ImprovementFormData({
    required this.suggestion,
    this.department,
    this.location,
    this.landmark,
    this.mediaUrls = const [],
  });

  Map<String, dynamic> toJson(String reporterId, String referenceId) {
    final trimmedSuggestion = suggestion.trim();
    return {
      'reporter_id': reporterId,
      'kind': 'suggestion',
      'reference_id': referenceId,
      'title': trimmedSuggestion.length > 80 ? '${trimmedSuggestion.substring(0, 80)}...' : trimmedSuggestion,
      'description': trimmedSuggestion,
      if (department != null && department!.isNotEmpty) 'category': department,
      if (location != null && location!.isNotEmpty) 'pin_address': location,
      if (landmark != null && landmark!.isNotEmpty) 'landmark': landmark,
    };
  }
}
