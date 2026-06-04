import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_idea_request.freezed.dart';
part 'create_idea_request.g.dart';

@freezed
abstract class CreateIdeaRequest with _$CreateIdeaRequest {
  const factory CreateIdeaRequest({
    required String topic,
    required String title,
    required String description,
    String? benefits,
    @Default([]) List<String> beneficiaries,
    @Default('public') String visibility,
    @Default(true) bool allowDiscussion,
    @Default(true) bool allowContact,
    @Default([]) List<String> mediaUrls,
  }) = _CreateIdeaRequest;

  factory CreateIdeaRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateIdeaRequestFromJson(json);
}
