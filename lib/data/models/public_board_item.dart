import 'package:flutter/material.dart';
import '../../core/constants/app_enums.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/utils/json_ids.dart';

class PublicBoardItem {
  final String id;
  final String kind;
  final String title;
  final SubmissionStatus status;
  final DateTime createdAt;
  final String? mediaUrl;
  final String? wardName;

  const PublicBoardItem({
    required this.id,
    required this.kind,
    required this.title,
    required this.status,
    required this.createdAt,
    this.mediaUrl,
    this.wardName,
  });

  String get timeAgo => DateFormatter.timeAgo(createdAt);

  String get kindLabel => switch (kind) {
        'report' => 'Issue',
        'idea' => 'Idea',
        'improvement' => 'Improvement',
        'appreciation' => 'Appreciation',
        _ => kind,
      };

  Color get kindColor => switch (kind) {
        'report' => AppColors.reportOrange,
        'idea' => AppColors.ideaPurple,
        'improvement' => AppColors.improveBlue,
        'appreciation' => AppColors.appreciateGreen,
        _ => AppColors.primary,
      };

  Color get kindColorLight => switch (kind) {
        'report' => AppColors.reportOrangeLight,
        'idea' => AppColors.ideaPurpleLight,
        'improvement' => AppColors.improveBlue.withValues(alpha: 0.12),
        'appreciation' => AppColors.appreciateGreenLight,
        _ => AppColors.primary.withValues(alpha: 0.12),
      };

  IconData get kindIcon => switch (kind) {
        'report' => Icons.report_rounded,
        'idea' => Icons.lightbulb_rounded,
        'improvement' => Icons.build_rounded,
        'appreciation' => Icons.favorite_rounded,
        _ => Icons.article_rounded,
      };

  factory PublicBoardItem.fromJson(Map<String, dynamic> json) {
    final ward = json['wards'] as Map?;
    final attachments = json['media_attachments'] as List?;
    final mediaUrl = attachments?.isNotEmpty == true
        ? (attachments!.first as Map)['url'] as String?
        : null;

    return PublicBoardItem(
      id: jsonIdToString(json['id']),
      kind: json['kind'] as String? ?? 'report',
      title: json['title'] as String? ?? '',
      status: SubmissionStatusX.fromString(json['status'] as String? ?? 'submitted'),
      createdAt: DateTime.parse(json['created_at'] as String),
      mediaUrl: mediaUrl,
      wardName: ward?['name'] as String?,
    );
  }
}
