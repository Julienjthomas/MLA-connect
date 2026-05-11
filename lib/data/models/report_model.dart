import '../../core/constants/app_enums.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/widgets/timeline_widget.dart';

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
    final media = (json['media_attachments'] as List?)
            ?.map((m) => m['url'] as String? ?? '')
            .where((u) => u.isNotEmpty)
            .toList() ??
        [];
    final timeline = (json['submission_status_history'] as List?)
            ?.map((t) => TimelineEvent(
                  date: DateFormatter.shortDate(DateTime.parse(t['created_at'] as String)),
                  title: SubmissionStatusX.fromString(t['to_status'] as String).label,
                  subtitle: t['notes'] as String? ?? '',
                ))
            .toList() ??
        [];
    return ReportModel(
      id: json['id'] as String,
      userId: json['reporter_id'] as String,
      category: ReportCategoryX.fromString(json['category'] as String? ?? 'other'),
      title: json['title'] as String,
      description: json['description'] as String,
      voiceNoteUrl: json['voice_message_url'] as String?,
      location: json['pin_address'] as String? ?? json['landmark'] as String? ?? '',
      landmark: json['landmark'] as String?,
      wardId: json['ward_id'] as String? ?? '',
      wardName: json['wards']?['name'] as String? ?? json['ward_id'] as String? ?? '',
      contactNumber: json['contact_phone'] as String?,
      status: SubmissionStatusX.fromString(json['status'] as String? ?? 'submitted'),
      createdAt: DateTime.parse(json['created_at'] as String),
      mediaUrls: media,
      timeline: timeline,
    );
  }

  String get timeAgo => DateFormatter.timeAgo(createdAt);
  String get shortId => 'RP${id.replaceAll('-', '').substring(0, 10).toUpperCase()}';
}

class ReportFormData {
  final ReportCategory category;
  final String title;
  final String description;
  final String location;
  final String? landmark;
  final String? wardId;
  final String? contactNumber;
  final List<String> mediaUrls;

  const ReportFormData({
    required this.category,
    required this.title,
    required this.description,
    required this.location,
    this.landmark,
    this.wardId,
    this.contactNumber,
    this.mediaUrls = const [],
  });

  Map<String, dynamic> toJson(String userId, String referenceId) => {
        'reporter_id': userId,
        'kind': 'report',
        'reference_id': referenceId,
        'category': category.dbValue,
        'title': title,
        'description': description,
        'pin_address': location,
        if (landmark != null && landmark!.isNotEmpty) 'landmark': landmark,
        if (wardId != null) 'ward_id': wardId,
        if (contactNumber != null && contactNumber!.isNotEmpty) 'contact_phone': contactNumber,
      };
}
