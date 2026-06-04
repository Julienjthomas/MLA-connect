import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/conversation/conversation_message.dart';
import '../../../data/models/conversation/conversation_thread.dart';
import '../../../data/services/conversation_service.dart';

class ChatController extends GetxController {
  final _service = ConversationService();

  final bodyController = TextEditingController();
  final scrollController = ScrollController();

  final RxList<ConversationThread> threads = <ConversationThread>[].obs;
  final Rx<ConversationThread?> activeThread = Rx(null);
  final RxList<ConversationMessage> messages = <ConversationMessage>[].obs;

  final RxBool loading = false.obs;
  final RxBool sending = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadThreads();
  }

  @override
  void onClose() {
    bodyController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  Future<void> loadThreads() async {
    loading.value = true;
    try {
      threads.value = await _service.getThreads();
      if (threads.isNotEmpty) {
        await openThread(threads.first);
      }
    } finally {
      loading.value = false;
    }
  }

  Future<void> openThread(ConversationThread thread) async {
    activeThread.value = thread;
    loading.value = true;
    try {
      final full = await _service.getThread(thread.id);
      if (full != null) activeThread.value = full;
    } finally {
      loading.value = false;
    }
  }

  Future<void> startNewThread() async {
    loading.value = true;
    try {
      final thread = await _service.createThread();
      if (thread != null) {
        threads.insert(0, thread);
        activeThread.value = thread;
        messages.clear();
      }
    } finally {
      loading.value = false;
    }
  }

  Future<void> send() async {
    final thread = activeThread.value;
    if (thread == null) {
      Get.snackbar('No conversation', 'Please start a conversation first.', snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (thread.status == 'closed') {
      Get.snackbar('Closed', 'This conversation is closed.', snackPosition: SnackPosition.BOTTOM);
      return;
    }
    final text = bodyController.text.trim();
    if (text.isEmpty) return;

    sending.value = true;
    try {
      final msg = await _service.sendMessage(thread.id, text);
      if (msg != null) {
        messages.add(msg);
        bodyController.clear();
        _scrollToBottom();
      }
    } catch (_) {
      Get.snackbar('Error', 'Could not send message. Try again.', snackPosition: SnackPosition.BOTTOM);
    } finally {
      sending.value = false;
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  bool get isClosed => activeThread.value?.status == 'closed';

  Future<void> closeActiveThread() async {
    final thread = activeThread.value;
    if (thread == null) return;
    await _service.closeThread(thread.id);
    await loadThreads();
  }
}
