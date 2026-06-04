import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_appreciation_request.freezed.dart';
part 'create_appreciation_request.g.dart';

@freezed
abstract class CreateAppreciationRequest with _$CreateAppreciationRequest {
  const factory CreateAppreciationRequest({
    required String recipientCategory,
    String? staffName,
    String? department,
    String? relatedWork,
    required String message,
    @Default('public') String visibility,
    @Default(false) bool anonymous,
    @Default([]) List<String> mediaUrls,
  }) = _CreateAppreciationRequest;

  factory CreateAppreciationRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateAppreciationRequestFromJson(json);
}
