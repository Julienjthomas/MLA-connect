import 'package:freezed_annotation/freezed_annotation.dart';

part 'mla_response.freezed.dart';
part 'mla_response.g.dart';

@freezed
abstract class MlaResponse with _$MlaResponse {
  const factory MlaResponse({
    required String id,
    required String name,
    String? photoUrl,
    String? coverImageUrl,
    @Default('') String bio,
    String? bioMl,
    @Default('') String term,
    @Default('') String constituency,
    String? education,
    @Default([]) List<String> galleryUrls,
    MlaStatsResponse? stats,
    MlaContactResponse? contact,
    @Default([]) List<MlaInitiativeResponse> initiatives,
  }) = _MlaResponse;

  factory MlaResponse.fromJson(Map<String, dynamic> json) =>
      _$MlaResponseFromJson(json);
}

@freezed
abstract class MlaStatsResponse with _$MlaStatsResponse {
  const factory MlaStatsResponse({
    @Default(0) int issuesResolved,
    @Default(0) int activeProjects,
    @Default(0) int appreciations,
    @Default(0) int ideasImplemented,
  }) = _MlaStatsResponse;

  factory MlaStatsResponse.fromJson(Map<String, dynamic> json) =>
      _$MlaStatsResponseFromJson(json);
}

@freezed
abstract class MlaContactResponse with _$MlaContactResponse {
  const factory MlaContactResponse({
    @Default('') String phone,
    String? whatsapp,
    String? email,
    String? officeAddress,
  }) = _MlaContactResponse;

  factory MlaContactResponse.fromJson(Map<String, dynamic> json) =>
      _$MlaContactResponseFromJson(json);
}

@freezed
abstract class MlaInitiativeResponse with _$MlaInitiativeResponse {
  const factory MlaInitiativeResponse({
    required String title,
    @Default('') String description,
  }) = _MlaInitiativeResponse;

  factory MlaInitiativeResponse.fromJson(Map<String, dynamic> json) =>
      _$MlaInitiativeResponseFromJson(json);
}
