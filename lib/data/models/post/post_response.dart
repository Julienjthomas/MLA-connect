import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_response.freezed.dart';
part 'post_response.g.dart';

@freezed
abstract class PostResponse with _$PostResponse {
  const factory PostResponse({
    required String id,
    required String title,
    required String body,
    String? titleMl,
    String? bodyMl,
    @Default('general') String category,
    String? imageUrl,
    @Default([]) List<String> mediaUrls,
    @Default(0) int likes,
    @Default(0) int views,
    @Default(false) bool isFeatured,
    required DateTime createdAt,
  }) = _PostResponse;

  factory PostResponse.fromJson(Map<String, dynamic> json) =>
      _$PostResponseFromJson(json);
}
