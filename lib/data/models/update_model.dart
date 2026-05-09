import '../../core/constants/app_enums.dart';
import '../../core/utils/date_formatter.dart';

class UpdateModel {
  final String id;
  final String title;
  final String body;
  final UpdateCategory category;
  final String? imageUrl;
  final int likes;
  final int views;
  final DateTime createdAt;

  const UpdateModel({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    this.imageUrl,
    this.likes = 0,
    this.views = 0,
    required this.createdAt,
  });

  factory UpdateModel.fromJson(Map<String, dynamic> json) => UpdateModel(
        id: json['id'] as String,
        title: json['title'] as String,
        body: json['body'] as String? ?? '',
        category: UpdateCategoryX.fromString(json['category'] as String? ?? ''),
        imageUrl: json['image_url'] as String?,
        likes: json['likes'] as int? ?? 0,
        views: json['views'] as int? ?? 0,
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  String get timeAgo => DateFormatter.timeAgo(createdAt);
  String get shortBody => body.length > 120 ? '${body.substring(0, 120)}...' : body;
}
