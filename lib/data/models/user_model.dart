import '../../core/utils/json_ids.dart';

class UserModel {
  /// Auth user id (`citizens.user_id` / `auth.users.id`).
  final String id;
  /// `citizens.id` / `profiles.id` — value for `submissions.reporter_id` (bigint or uuid per DB).
  final String? citizenRowId;
  final String name;
  final String phone;
  final String? email;
  final String? avatarUrl;
  final String language;
  final String? constituencyId;
  final String? constituencyName;
  final String? localBodyId;
  final String? localBodyName;
  final String? wardId;
  final String? wardName;
  final DateTime? onboardedAt;
  final DateTime? wardUpdatedAt;
  final int contributionCount;

  const UserModel({
    required this.id,
    this.citizenRowId,
    required this.name,
    required this.phone,
    this.email,
    this.avatarUrl,
    this.language = 'en',
    this.constituencyId,
    this.constituencyName,
    this.localBodyId,
    this.localBodyName,
    this.wardId,
    this.wardName,
    this.onboardedAt,
    this.wardUpdatedAt,
    this.contributionCount = 0,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final oa = json['onboarded_at'];
    DateTime? onboardedAt;
    if (oa is String) {
      onboardedAt = DateTime.tryParse(oa);
    }
    return UserModel(
        id: jsonIdToString(json['user_id'] ?? json['id']),
        citizenRowId: jsonIdToNullableString(json['id']),
        name: json['full_name'] as String? ?? '',
        phone: json['phone'] as String? ?? '',
        email: json['email'] as String?,
        avatarUrl: json['avatar_url'] as String?,
        language: json['language'] as String? ?? 'en',
        constituencyId: jsonIdToNullableString(json['constituency_id']),
        constituencyName: json['constituencies']?['name'] as String?,
        localBodyId: jsonIdToNullableString(json['local_body_id']),
        localBodyName: json['local_bodies']?['name'] as String?,
        wardId: jsonIdToNullableString(json['ward_id']),
        wardName: json['wards']?['name'] as String?,
        onboardedAt: onboardedAt,
        wardUpdatedAt: json['ward_updated_at'] is String
            ? DateTime.tryParse(json['ward_updated_at'] as String)
            : null,
        contributionCount: json['contribution_count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'full_name': name,
        'phone': phone,
        if (email != null) 'email': email,
        if (avatarUrl != null) 'avatar_url': avatarUrl,
        'language': language,
        if (constituencyId != null) 'constituency_id': constituencyId,
        if (localBodyId != null) 'local_body_id': localBodyId,
        if (wardId != null) 'ward_id': wardId,
      };

  UserModel copyWith({
    String? citizenRowId,
    String? name,
    String? phone,
    String? email,
    String? avatarUrl,
    String? language,
    String? constituencyId,
    String? constituencyName,
    String? localBodyId,
    String? localBodyName,
    String? wardId,
    String? wardName,
    DateTime? onboardedAt,
    int? contributionCount,
  }) =>
      UserModel(
        id: id,
        citizenRowId: citizenRowId ?? this.citizenRowId,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        language: language ?? this.language,
        constituencyId: constituencyId ?? this.constituencyId,
        constituencyName: constituencyName ?? this.constituencyName,
        localBodyId: localBodyId ?? this.localBodyId,
        localBodyName: localBodyName ?? this.localBodyName,
        wardId: wardId ?? this.wardId,
        wardName: wardName ?? this.wardName,
        onboardedAt: onboardedAt ?? this.onboardedAt,
        wardUpdatedAt: this.wardUpdatedAt,
        contributionCount: contributionCount ?? this.contributionCount,
      );
}

class LocalBodyModel {
  final String id;
  final String name;
  final String type;
  final String? constituencyId;

  const LocalBodyModel({
    required this.id,
    required this.name,
    required this.type,
    this.constituencyId,
  });

  factory LocalBodyModel.fromJson(Map<String, dynamic> json) => LocalBodyModel(
        id: jsonIdToString(json['id']),
        name: json['name'] as String? ?? '',
        type: json['type'] as String? ?? 'panchayat',
        constituencyId: jsonIdToNullableString(json['constituency_id']),
      );
}

class WardModel {
  final String id;
  final String localBodyId;
  final int wardNumber;
  final String name;

  const WardModel({
    required this.id,
    required this.localBodyId,
    required this.wardNumber,
    required this.name,
  });

  factory WardModel.fromJson(Map<String, dynamic> json) => WardModel(
        id: jsonIdToString(json['id']),
        localBodyId: jsonIdToString(json['local_body_id']),
        wardNumber: json['ward_number'] as int,
        name: json['name'] as String,
      );

  String get displayName => 'Ward $wardNumber – $name';
}
