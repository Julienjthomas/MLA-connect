import 'package:freezed_annotation/freezed_annotation.dart';

part 'local_body_response.freezed.dart';
part 'local_body_response.g.dart';

@freezed
abstract class LocalBodyResponse with _$LocalBodyResponse {
  const factory LocalBodyResponse({
    required String id,
    required String name,
    @Default('panchayat') String type,
    String? constituencyId,
  }) = _LocalBodyResponse;

  factory LocalBodyResponse.fromJson(Map<String, dynamic> json) =>
      _$LocalBodyResponseFromJson(json);
}
