import 'package:freezed_annotation/freezed_annotation.dart';

part 'conversation_thread.freezed.dart';
part 'conversation_thread.g.dart';

@freezed
abstract class ConversationThread with _$ConversationThread {
  const factory ConversationThread({
    required String id,
    required String citizenId,
    required String constituencyId,
    @Default('open') String status,
    required DateTime createdAt,
    DateTime? lastMessageAt,
  }) = _ConversationThread;

  factory ConversationThread.fromJson(Map<String, dynamic> json) =>
      _$ConversationThreadFromJson(json);
}
