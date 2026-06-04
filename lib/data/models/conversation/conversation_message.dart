import 'package:freezed_annotation/freezed_annotation.dart';

part 'conversation_message.freezed.dart';
part 'conversation_message.g.dart';

@freezed
abstract class ConversationMessage with _$ConversationMessage {
  const factory ConversationMessage({
    required String id,
    required String threadId,
    @Default('citizen') String senderType,
    required String body,
    required DateTime createdAt,
  }) = _ConversationMessage;

  factory ConversationMessage.fromJson(Map<String, dynamic> json) =>
      _$ConversationMessageFromJson(json);
}
