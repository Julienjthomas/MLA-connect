class OfficeMessageModel {
  final String id;
  final String threadId;
  final String senderType;
  final String body;
  final DateTime createdAt;

  const OfficeMessageModel({
    required this.id,
    required this.threadId,
    required this.senderType,
    required this.body,
    required this.createdAt,
  });

  bool get fromCitizen => senderType == 'citizen';

  factory OfficeMessageModel.fromJson(Map<String, dynamic> json) => OfficeMessageModel(
        id: json['id'] as String? ?? '',
        threadId: json['thread_id'] as String? ?? '',
        senderType: json['sender_type'] as String? ?? 'citizen',
        body: json['body'] as String? ?? '',
        createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
      );
}
