class UserModel {
  final String id;
  final String name;
  final String phone;
  final String? email;
  final String? avatarUrl;
  final String language;
  final String? panchayatId;
  final String? panchayatName;
  final String? wardId;
  final String? wardName;

  const UserModel({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.avatarUrl,
    this.language = 'en',
    this.panchayatId,
    this.panchayatName,
    this.wardId,
    this.wardName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String,
        name: json['name'] as String? ?? '',
        phone: json['phone'] as String? ?? '',
        email: json['email'] as String?,
        avatarUrl: json['avatar_url'] as String?,
        language: json['language'] as String? ?? 'en',
        panchayatId: json['panchayat_id'] as String?,
        panchayatName: json['panchayats']?['name'] as String?,
        wardId: json['ward_id'] as String?,
        wardName: json['wards']?['name'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'phone': phone,
        if (email != null) 'email': email,
        if (avatarUrl != null) 'avatar_url': avatarUrl,
        'language': language,
        if (panchayatId != null) 'panchayat_id': panchayatId,
        if (wardId != null) 'ward_id': wardId,
      };

  UserModel copyWith({
    String? name,
    String? phone,
    String? email,
    String? avatarUrl,
    String? language,
    String? panchayatId,
    String? panchayatName,
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
        panchayatId: panchayatId ?? this.panchayatId,
        panchayatName: panchayatName ?? this.panchayatName,
        wardId: wardId ?? this.wardId,
        wardName: wardName ?? this.wardName,
      );
}

class PanchayatModel {
  final String id;
  final String name;

  const PanchayatModel({required this.id, required this.name});

  factory PanchayatModel.fromJson(Map<String, dynamic> json) =>
      PanchayatModel(id: json['id'] as String, name: json['name'] as String);
}

class WardModel {
  final String id;
  final String panchayatId;
  final int number;
  final String name;

  const WardModel({required this.id, required this.panchayatId, required this.number, required this.name});

  factory WardModel.fromJson(Map<String, dynamic> json) => WardModel(
        id: json['id'] as String,
        panchayatId: json['panchayat_id'] as String,
        number: json['number'] as int,
        name: json['name'] as String,
      );

  String get displayName => 'Ward $number – $name';
}
