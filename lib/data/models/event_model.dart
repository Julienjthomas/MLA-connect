import '../../core/utils/date_formatter.dart';
import '../../core/utils/json_ids.dart';

class EventModel {
  final String id;
  final String title;
  final String? description;
  final String kind;
  final DateTime startsAt;
  final DateTime? endsAt;
  final String? venueName;
  final String? venueAddress;
  final String? coverImageUrl;
  final DateTime createdAt;

  const EventModel({
    required this.id,
    required this.title,
    this.description,
    required this.kind,
    required this.startsAt,
    this.endsAt,
    this.venueName,
    this.venueAddress,
    this.coverImageUrl,
    required this.createdAt,
  });

  String get timeAgo => DateFormatter.timeAgo(createdAt);

  String get venue => venueName ?? venueAddress ?? '';

  String get formattedTime {
    String fmt(DateTime dt) {
      final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
      final m = dt.minute.toString().padLeft(2, '0');
      final p = dt.hour < 12 ? 'AM' : 'PM';
      return '$h:$m $p';
    }
    if (endsAt != null) return '${fmt(startsAt)} – ${fmt(endsAt!)}';
    return fmt(startsAt);
  }

  String get shortMonth {
    const months = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
    return months[(startsAt.month - 1).clamp(0, 11)];
  }

  String get shortWeekday {
    const days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    return days[(startsAt.weekday - 1).clamp(0, 6)];
  }

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
        id: jsonIdToString(json['id']),
        title: json['title'] as String,
        description: json['description'] as String?,
        kind: json['kind'] as String? ?? 'general',
        startsAt: DateTime.parse(json['starts_at'] as String).toLocal(),
        endsAt: json['ends_at'] != null ? DateTime.parse(json['ends_at'] as String).toLocal() : null,
        venueName: json['venue_name'] as String?,
        venueAddress: json['venue_address'] as String?,
        coverImageUrl: json['cover_image_url'] as String?,
        createdAt: DateTime.parse(json['created_at'] as String),
      );
}
