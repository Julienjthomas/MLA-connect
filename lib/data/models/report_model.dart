import '../../core/constants/app_enums.dart';
import '../../core/utils/json_ids.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/widgets/timeline_widget.dart';
import '../utils/submission_media_refs.dart';

class ReportModel {
  final String id;
  final String userId;
  final ReportCategory category;
  final String title;
  final String description;
  final String? voiceNoteUrl;
  final String location;
  final String? landmark;
  final String wardId;
  final String wardName;
  final String? contactNumber;
  final SubmissionStatus status;
  final DateTime createdAt;
  final List<String> mediaUrls;
  final List<TimelineEvent> timeline;

  const ReportModel({
    required this.id,
    required this.userId,
    required this.category,
    required this.title,
    required this.description,
    this.voiceNoteUrl,
    required this.location,
    this.landmark,
    required this.wardId,
    required this.wardName,
    this.contactNumber,
    required this.status,
    required this.createdAt,
    this.mediaUrls = const [],
    this.timeline = const [],
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    final media = submissionMediaRefsFromJson(json);
    final timeline = (json['submission_status_history'] as List?)
            ?.map((t) => TimelineEvent(
                  date: DateFormatter.shortDate(DateTime.parse(t['created_at'] as String)),
                  title: SubmissionStatusX.fromString(t['to_status'] as String).label,
                  subtitle: t['notes'] as String? ?? '',
                ))
            .toList() ??
        [];
    return ReportModel(
      id: jsonIdToString(json['id']),
      userId: jsonIdToString(json['reporter_id']),
      category: ReportCategoryX.fromString(json['category'] as String? ?? 'other'),
      title: json['title'] as String,
      description: json['description'] as String,
      voiceNoteUrl: json['voice_message_url'] as String?,
      location: json['pin_address'] as String? ?? json['landmark'] as String? ?? '',
      landmark: json['landmark'] as String?,
      wardId: jsonIdToNullableString(json['ward_id']) ?? '',
      wardName: json['wards']?['name'] as String? ?? jsonIdToNullableString(json['ward_id']) ?? '',
      contactNumber: json['contact_phone'] as String?,
      status: SubmissionStatusX.fromString(json['status'] as String? ?? 'submitted'),
      createdAt: DateTime.parse(json['created_at'] as String),
      mediaUrls: media,
      timeline: timeline,
    );
  }

  String get timeAgo => DateFormatter.timeAgo(createdAt);
  String get shortId {
    final compact = id.replaceAll('-', '');
    final prefix =
        compact.length <= 10 ? compact : compact.substring(0, 10);
    return 'RP${prefix.toUpperCase()}';
  }
}

class ReportFormData {
  final ReportCategory category;
  final String? customCategory;
  final String title;
  final String description;
  final String location;
  final String? landmark;
  /// DB FK — from profile or ward picker when resolved to a row id.
  final String? wardId;
  final String? localBodyId;
  final String? panchayath;
  final String? ward;
  final String? contactNumber;
  final List<String> mediaUrls;
  final String? voiceMessageUrl;
  final SubmissionVisibility visibility;

  const ReportFormData({
    required this.category,
    this.customCategory,
    required this.title,
    required this.description,
    required this.location,
    this.landmark,
    this.wardId,
    this.localBodyId,
    this.panchayath,
    this.ward,
    this.contactNumber,
    this.mediaUrls = const [],
    this.voiceMessageUrl,
    this.visibility = SubmissionVisibility.public,
  });

  Map<String, dynamic> toJson(String userId, String referenceId) => {
        'reporter_id': userId,
        'kind': 'report',
        'reference_id': referenceId,
        'category': category == ReportCategory.other &&
                customCategory != null &&
                customCategory!.trim().isNotEmpty
            ? customCategory!.trim()
            : category.dbValue,
        'title': title,
        'description': description,
        'pin_address': location,
        if (landmark != null && landmark!.isNotEmpty) 'landmark': landmark,
        if (localBodyId != null && localBodyId!.isNotEmpty && _isDbId(localBodyId!)) 'local_body_id': localBodyId,
        if (wardId != null && wardId!.isNotEmpty && _isDbId(wardId!)) 'ward_id': wardId,
        if (contactNumber != null && contactNumber!.isNotEmpty) 'contact_phone': contactNumber,
        if (voiceMessageUrl != null && voiceMessageUrl!.isNotEmpty) 'voice_message_url': voiceMessageUrl,
        'visibility': visibility.submissionDbValue,
        'is_anonymous': visibility == SubmissionVisibility.anonymous,
      };

  // Skip synthetic fallback ids (e.g. 'fallback-lb-…') that aren't real FKs.
  static bool _isDbId(String id) => !id.startsWith('fallback-');
}
