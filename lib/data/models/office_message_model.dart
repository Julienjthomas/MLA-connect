import '../../core/utils/json_ids.dart';

class OfficeMessageModel {
  final String id;
  final String constituencyId;
  final String category;
  final String body;
  final DateTime createdAt;

  const OfficeMessageModel({
    required this.id,
    required this.constituencyId,
    required this.category,
    required this.body,
    required this.createdAt,
  });

  factory OfficeMessageModel.fromJson(Map<String, dynamic> json) => OfficeMessageModel(
        id: jsonIdToString(json['id']),
        constituencyId: jsonIdToString(json['constituency_id']),
        category: json['category'] as String? ?? 'other',
        body: json['body'] as String? ?? '',
        createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
      );
}
