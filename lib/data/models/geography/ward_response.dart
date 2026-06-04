import 'package:freezed_annotation/freezed_annotation.dart';

part 'ward_response.freezed.dart';
part 'ward_response.g.dart';

@freezed
abstract class WardResponse with _$WardResponse {
  const factory WardResponse({
    required String id,
    required String localBodyId,
    required int wardNumber,
    String? name,
  }) = _WardResponse;

  factory WardResponse.fromJson(Map<String, dynamic> json) =>
      _$WardResponseFromJson(json);
}
