import 'package:get/get.dart';
import '../../core/constants/app_enums.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/utils/json_ids.dart';

class UpdateModel {
  final String id;
  final String title;
  final String body;
  final String? titleMl;
  final String? bodyMl;
  final UpdateCategory category;
  final String? imageUrl;
  final int likes;
  final int views;
  final DateTime createdAt;

  const UpdateModel({
    required this.id,
    required this.title,
    required this.body,
    this.titleMl,
    this.bodyMl,
    required this.category,
    this.imageUrl,
    this.likes = 0,
    this.views = 0,
    required this.createdAt,
  });

  factory UpdateModel.fromJson(Map<String, dynamic> json) => UpdateModel(
        id: jsonIdToString(json['id']),
        title: json['title'] as String,
        body: json['body'] as String? ?? '',
        titleMl: json['title_ml'] as String?,
        bodyMl: json['body_ml'] as String?,
        category: UpdateCategoryX.fromString(json['category'] as String? ?? ''),
        imageUrl: json['cover_image_url'] as String?,
        likes: json['like_count'] as int? ?? 0,
        views: json['view_count'] as int? ?? 0,
        createdAt: DateTime.parse(
          json['published_at'] as String? ?? json['created_at'] as String,
        ),
      );

  // Returns localised title/body based on current app locale
  String get localTitle {
    final isMl = Get.locale?.languageCode == 'ml';
    return (isMl && titleMl != null && titleMl!.isNotEmpty) ? titleMl! : title;
  }

  String get localBody {
    final isMl = Get.locale?.languageCode == 'ml';
    return (isMl && bodyMl != null && bodyMl!.isNotEmpty) ? bodyMl! : body;
  }

  String get timeAgo => DateFormatter.timeAgo(createdAt);
  String get shortBody => localBody.length > 120 ? '${localBody.substring(0, 120)}...' : localBody;
}
