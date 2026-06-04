import 'package:freezed_annotation/freezed_annotation.dart';

part 'idea_response.freezed.dart';
part 'idea_response.g.dart';

@freezed
abstract class IdeaResponse with _$IdeaResponse {
  const factory IdeaResponse({
    required String id,
    required String citizenId,
    @Default('general') String topic,
    required String title,
    required String description,
    String? benefits,
    @Default([]) List<String> beneficiaries,
    @Default('public') String visibility,
    @Default(true) bool allowDiscussion,
    @Default(true) bool allowContact,
    @Default('submitted') String status,
    required DateTime createdAt,
    @Default([]) List<String> mediaUrls,
    @Default(0) int upvotes,
    @Default(0) int downvotes,
  }) = _IdeaResponse;

  factory IdeaResponse.fromJson(Map<String, dynamic> json) =>
      _$IdeaResponseFromJson(json);
}
