import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/conversation/conversation_message.dart';
import '../models/conversation/conversation_thread.dart';
import '../models/conversation/send_message_request.dart';

part 'conversations_api.g.dart';

@RestApi()
abstract class ConversationsApi {
  factory ConversationsApi(Dio dio, {String? baseUrl}) = _ConversationsApi;

  @POST('/citizens/:citizenId/conversations/threads')
  Future<ConversationThread> createThread(
      @Body() Map<String, dynamic> body);

  @GET('/citizens/:citizenId/conversations/threads')
  Future<List<ConversationThread>> getThreads();

  @GET('/citizens/:citizenId/conversations/threads/{threadId}')
  Future<ConversationThread> getThread(@Path('threadId') String threadId);

  @POST('/citizens/:citizenId/conversations/threads/{threadId}/messages')
  Future<ConversationMessage> sendMessage(
    @Path('threadId') String threadId,
    @Body() SendMessageRequest request,
  );

  @POST('/citizens/:citizenId/conversations/threads/{threadId}/close')
  Future<void> closeThread(@Path('threadId') String threadId);
}
