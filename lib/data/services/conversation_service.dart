import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../models/conversation/conversation_message.dart';
import '../models/conversation/conversation_thread.dart';
import '../models/conversation/send_message_request.dart';
import '../remote/conversations_api.dart';

class ConversationService {
  ConversationsApi get _api => Get.find<ConversationsApi>();

  Future<List<ConversationThread>> getThreads() async {
    try {
      return await _api.getThreads();
    } catch (e) {
      debugPrint('[ConversationService] getThreads error: $e');
      return [];
    }
  }

  Future<ConversationThread?> createThread({String? title}) async {
    try {
      return await _api.createThread({'title': title ?? 'New conversation'});
    } catch (e) {
      debugPrint('[ConversationService] createThread error: $e');
      return null;
    }
  }

  Future<ConversationThread?> getThread(String threadId) async {
    try {
      return await _api.getThread(threadId);
    } catch (e) {
      debugPrint('[ConversationService] getThread error: $e');
      return null;
    }
  }

  Future<ConversationMessage?> sendMessage(String threadId, String text) async {
    try {
      return await _api.sendMessage(threadId, SendMessageRequest(body: text));
    } catch (e) {
      debugPrint('[ConversationService] sendMessage error: $e');
      return null;
    }
  }

  Future<void> closeThread(String threadId) async {
    try {
      await _api.closeThread(threadId);
    } catch (e) {
      debugPrint('[ConversationService] closeThread error: $e');
    }
  }
}
