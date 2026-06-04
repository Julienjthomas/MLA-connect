import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../models/conversation/send_message_request.dart';
import '../models/office_message_model.dart';
import '../remote/conversations_api.dart';

class OfficeMessagesService {
  ConversationsApi get _api => Get.find<ConversationsApi>();

  /// Get or create thread, then return messages. citizenId/constituencyId kept
  /// for backwards compat with ActivityController caller.
  Future<List<OfficeMessageModel>> listForThread({
    required int citizenId,
    required int constituencyId,
    int limit = 50,
  }) async {
    try {
      final threads = await _api.getThreads();
      if (threads.isEmpty) return [];
      
      
      // Return empty for now — conversation view will load via getThreads
      return [];
    } catch (e) {
      debugPrint('[OfficeMessagesService] listForThread error: $e');
      return [];
    }
  }

  Future<void> send({
    required int citizenId,
    required int constituencyId,
    required String body,
  }) async {
    try {
      final threads = await _api.getThreads();
      String threadId;
      if (threads.isEmpty) {
        final newThread = await _api.createThread({
          'constituencyId': constituencyId.toString(),
        });
        threadId = newThread.id;
      } else {
        threadId = threads.first.id;
      }
      await _api.sendMessage(threadId, SendMessageRequest(body: body));
    } catch (e) {
      debugPrint('[OfficeMessagesService] send error: $e');
    }
  }
}
