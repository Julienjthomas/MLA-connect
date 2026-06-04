import 'package:freezed_annotation/freezed_annotation.dart';

part 'personal_info_request.freezed.dart';
part 'personal_info_request.g.dart';

@freezed
abstract class PersonalInfoRequest with _$PersonalInfoRequest {
  const factory PersonalInfoRequest({
    String? name,
    String? phone,
    String? email,
    String? language,
    String? constituencyId,
    String? localBodyId,
    String? wardId,
    DateTime? onboardedAt,
  }) = _PersonalInfoRequest;

  factory PersonalInfoRequest.fromJson(Map<String, dynamic> json) =>
      _$PersonalInfoRequestFromJson(json);
}
