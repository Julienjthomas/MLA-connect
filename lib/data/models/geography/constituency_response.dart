import 'package:freezed_annotation/freezed_annotation.dart';

part 'constituency_response.freezed.dart';
part 'constituency_response.g.dart';

@freezed
abstract class ConstituencyResponse with _$ConstituencyResponse {
  const factory ConstituencyResponse({
    required String id,
    required String name,
    String? slug,
  }) = _ConstituencyResponse;

  factory ConstituencyResponse.fromJson(Map<String, dynamic> json) =>
      _$ConstituencyResponseFromJson(json);
}
