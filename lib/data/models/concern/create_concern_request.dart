import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_concern_request.freezed.dart';
part 'create_concern_request.g.dart';

@freezed
abstract class CreateConcernRequest with _$CreateConcernRequest {
  const factory CreateConcernRequest({
    required String category,
    required String title,
    required String description,
    String? location,
    String? landmark,
    String? voiceNoteUrl,
    String? wardId,
    String? localBodyId,
    String? contactNumber,
    @Default([]) List<String> mediaUrls,
  }) = _CreateConcernRequest;

  factory CreateConcernRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateConcernRequestFromJson(json);
}
