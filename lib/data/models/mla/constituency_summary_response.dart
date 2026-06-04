import 'package:freezed_annotation/freezed_annotation.dart';

part 'constituency_summary_response.freezed.dart';
part 'constituency_summary_response.g.dart';

@freezed
abstract class ConstituencySummaryResponse with _$ConstituencySummaryResponse {
  const factory ConstituencySummaryResponse({
    required String id,
    required String name,
    String? constituencyId,
    Map<String, dynamic>? stats,
  }) = _ConstituencySummaryResponse;

  factory ConstituencySummaryResponse.fromJson(Map<String, dynamic> json) =>
      _$ConstituencySummaryResponseFromJson(json);
}
