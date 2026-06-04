import 'package:freezed_annotation/freezed_annotation.dart';

part 'appreciation_response.freezed.dart';
part 'appreciation_response.g.dart';

@freezed
abstract class AppreciationResponse with _$AppreciationResponse {
  const factory AppreciationResponse({
    required String id,
    required String citizenId,
    required String recipientCategory,
    String? staffName,
    String? department,
    String? relatedWork,
    required String message,
    @Default('public') String visibility,
    @Default(false) bool anonymous,
    @Default('submitted') String status,
    required DateTime createdAt,
    @Default([]) List<String> mediaUrls,
  }) = _AppreciationResponse;

  factory AppreciationResponse.fromJson(Map<String, dynamic> json) =>
      _$AppreciationResponseFromJson(json);
}
