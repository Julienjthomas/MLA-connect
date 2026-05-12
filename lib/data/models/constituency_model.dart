import '../../core/utils/json_ids.dart';

class ConstituencyModel {
  final String id;
  final String name;
  final String? slug;

  const ConstituencyModel({required this.id, required this.name, this.slug});

  factory ConstituencyModel.fromJson(Map<String, dynamic> json) => ConstituencyModel(
        id: jsonIdToString(json['id']),
        name: json['name'] as String? ?? '',
        slug: json['slug'] as String?,
      );
}
