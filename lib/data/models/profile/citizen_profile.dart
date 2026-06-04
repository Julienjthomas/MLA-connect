import 'package:freezed_annotation/freezed_annotation.dart';

part 'citizen_profile.freezed.dart';
part 'citizen_profile.g.dart';

@freezed
abstract class CitizenProfile with _$CitizenProfile {
  const factory CitizenProfile({
    required String id,
    required String name,
    required String phone,
    String? email,
    String? avatarUrl,
    @Default('en') String language,
    String? constituencyId,
    String? constituencyName,
    String? localBodyId,
    String? localBodyName,
    String? wardId,
    String? wardName,
    DateTime? onboardedAt,
    DateTime? wardUpdatedAt,
    @Default(0) int contributionCount,
  }) = _CitizenProfile;

  factory CitizenProfile.fromJson(Map<String, dynamic> json) =>
      _$CitizenProfileFromJson(json);
}
