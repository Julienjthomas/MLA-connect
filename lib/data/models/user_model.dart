class UserModel {
  final String id;
  final String name;
  final String phone;
  final String? email;
  final String? avatarUrl;
  final String language;
  final String? localBodyId;
  final String? localBodyName;
  final String? wardId;
  final String? wardName;

  const UserModel({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.avatarUrl,
    this.language = 'en',
    this.localBodyId,
    this.localBodyName,
    this.wardId,
    this.wardName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: (json['user_id'] ?? json['id']) as String,
        name: json['full_name'] as String? ?? '',
        phone: json['phone'] as String? ?? '',
        email: json['email'] as String?,
        avatarUrl: json['avatar_url'] as String?,
        language: json['language'] as String? ?? 'en',
        localBodyId: json['local_body_id'] as String?,
        localBodyName: json['local_bodies']?['name'] as String?,
        wardId: json['ward_id'] as String?,
        wardName: json['wards']?['name'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'full_name': name,
        'phone': phone,
        if (email != null) 'email': email,
        if (avatarUrl != null) 'avatar_url': avatarUrl,
        'language': language,
        if (localBodyId != null) 'local_body_id': localBodyId,
        if (wardId != null) 'ward_id': wardId,
      };

  UserModel copyWith({
    String? name,
    String? phone,
    String? email,
    String? avatarUrl,
    String? language,
    String? localBodyId,
    String? localBodyName,
    String? wardId,
    String? wardName,
  }) =>
      UserModel(
        id: id,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        language: language ?? this.language,
        localBodyId: localBodyId ?? this.localBodyId,
        localBodyName: localBodyName ?? this.localBodyName,
        wardId: wardId ?? this.wardId,
        wardName: wardName ?? this.wardName,
      );
}

class LocalBodyModel {
  final String id;
  final String name;
  final String type;

  const LocalBodyModel({required this.id, required this.name, required this.type});

  factory LocalBodyModel.fromJson(Map<String, dynamic> json) => LocalBodyModel(
        id: json['id'] as String,
        name: json['name'] as String,
        type: json['type'] as String? ?? 'panchayat',
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
        id: json['id'] as String,
        localBodyId: json['local_body_id'] as String,
        wardNumber: json['ward_number'] as int,
        name: json['name'] as String,
      );

  String get displayName => 'Ward $wardNumber – $name';
}
