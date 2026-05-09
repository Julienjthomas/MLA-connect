import '../../core/constants/app_enums.dart';
import '../../core/utils/date_formatter.dart';

class ImprovementModel {
  final String id;
  final String userId;
  final String suggestion;
  final String? department;
  final String? location;
  final String? landmark;
  final SubmissionStatus status;
  final DateTime createdAt;

  const ImprovementModel({
    required this.id,
    required this.userId,
    required this.suggestion,
    this.department,
    this.location,
    this.landmark,
    required this.status,
    required this.createdAt,
  });

  factory ImprovementModel.fromJson(Map<String, dynamic> json) => ImprovementModel(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        suggestion: json['suggestion'] as String? ?? '',
        department: json['department'] as String?,
        location: json['location'] as String?,
        landmark: json['landmark'] as String?,
        status: SubmissionStatusX.fromString(json['status'] as String? ?? 'submitted'),
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  String get timeAgo => DateFormatter.timeAgo(createdAt);
}

class ImprovementFormData {
  final String suggestion;
  final String? department;
  final String? location;
  final String? landmark;

  const ImprovementFormData({
    required this.suggestion,
    this.department,
    this.location,
    this.landmark,
  });

  Map<String, dynamic> toJson(String userId) => {
        'user_id': userId,
        'suggestion': suggestion,
        if (department != null && department!.isNotEmpty) 'department': department,
        if (location != null && location!.isNotEmpty) 'location': location,
        if (landmark != null && landmark!.isNotEmpty) 'landmark': landmark,
        'status': 'submitted',
      };
}
