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
  final List<String> mediaUrls;
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
    this.mediaUrls = const [],
    this.likes = 0,
    this.views = 0,
    required this.createdAt,
  });

  factory UpdateModel.fromJson(Map<String, dynamic> json) {
    final coverUrl = json['cover_image_url'] as String?;
    final attachments = (json['media_attachments'] as List?)
            ?.map((raw) {
              final m = Map<String, dynamic>.from(raw as Map);
              final url = m['url'] as String?;
              final sp = m['storage_path'] as String?;
              // signed url injected by service, or direct url, or storage_path fallback
              final signed = m['_signed_url'] as String?;
              if (signed != null && signed.isNotEmpty) return signed;
              if (url != null && url.trim().isNotEmpty) return url.trim();
              if (sp != null && sp.trim().isNotEmpty) return sp.trim();
              return '';
            })
            .where((v) => v.isNotEmpty)
            .toList() ??
        [];

    return UpdateModel(
      id: jsonIdToString(json['id']),
      title: json['title'] as String,
      body: json['body'] as String? ?? '',
      titleMl: json['title_ml'] as String?,
      bodyMl: json['body_ml'] as String?,
      category: UpdateCategoryX.fromString(json['category'] as String? ?? ''),
      imageUrl: coverUrl,
      mediaUrls: List<String>.from(attachments),
      likes: json['like_count'] as int? ?? 0,
      views: json['view_count'] as int? ?? 0,
      createdAt: DateTime.parse(
        json['published_at'] as String? ?? json['created_at'] as String,
      ),
    );
  }

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
