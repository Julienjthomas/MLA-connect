class CitizenNotification {
  const CitizenNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.isRead,
    required this.createdAt,
    this.subtype,
    this.targetType,
    this.targetId,
    this.imageUrl,
    this.actionUrl,
  });

  final int id;
  final String title;
  final String body;
  final String type;
  final bool isRead;
  final DateTime createdAt;
  final String? subtype;
  final String? targetType;
  final int? targetId;
  final String? imageUrl;
  final String? actionUrl;

  factory CitizenNotification.fromJson(Map<String, dynamic> json) {
    return CitizenNotification(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      type: json['type'] as String? ?? '',
      isRead: json['is_read'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      subtype: json['subtype'] as String?,
      targetType: json['target_type'] as String?,
      targetId: json['target_id'] as int?,
      imageUrl: json['image_url'] as String?,
      actionUrl: json['action_url'] as String?,
    );
  }
}
