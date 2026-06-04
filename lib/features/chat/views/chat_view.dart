import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/conversation/conversation_message.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/chat_controller.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    return Scaffold(
      backgroundColor: AppColors.surfaceVariant,
      appBar: AppBar(
        title: const Text('Chat with MLA office', style: AppTextStyles.titleLarge),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        actions: [
          Obx(() => controller.activeThread.value != null && !controller.isClosed
              ? TextButton(
                  onPressed: () async {
                    final ok = await Get.dialog<bool>(AlertDialog(
                      title: const Text('Close conversation?'),
                      content: const Text('You won\'t be able to send more messages.'),
                      actions: [
                        TextButton(onPressed: () => Get.back(result: false), child: const Text('Cancel')),
                        TextButton(onPressed: () => Get.back(result: true), child: const Text('Close')),
                      ],
                    ));
                    if (ok == true) {
                      await controller.closeActiveThread();
                    }
                  },
                  child: const Text('Close', style: TextStyle(color: AppColors.statusRejected)),
                )
              : const SizedBox.shrink()),
        ],
      ),
      body: Obx(() {
        if (auth.userId == null) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text('Sign in to chat with the MLA office.', style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
            ),
          );
        }
        if (controller.loading.value && controller.threads.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.threads.isEmpty) {
          return _NoThreadsState(onStart: controller.startNewThread);
        }
        return Column(
          children: [
            if (controller.activeThread.value?.status == 'closed')
              Container(
                width: double.infinity,
                color: AppColors.grey200,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: const Text('This conversation is closed.', style: AppTextStyles.bodySmall, textAlign: TextAlign.center),
              ),
            Expanded(child: _MessageList()),
            if (!controller.isClosed) _InputBar(controller: controller),
          ],
        );
      }),
    );
  }
}

class _MessageList extends GetView<ChatController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final msgs = controller.messages;
      if (msgs.isEmpty && !controller.loading.value) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.chat_bubble_outline_rounded, size: 48, color: AppColors.grey300),
              const SizedBox(height: 12),
              const Text('No messages yet.', style: AppTextStyles.bodyMedium),
              const SizedBox(height: 6),
              const Text('Send a message to start the conversation.', style: AppTextStyles.bodySmall),
            ],
          ),
        );
      }
      return ListView.builder(
        controller: controller.scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: msgs.length,
        itemBuilder: (_, i) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _MessageBubble(msg: msgs[i]),
        ),
      );
    });
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.msg});
  final ConversationMessage msg;

  bool get _fromCitizen => msg.senderType == 'citizen';

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: _fromCitizen ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (!_fromCitizen) ...[
          const CircleAvatar(
            radius: 18,
            backgroundColor: Color(0xFFD8D0F5),
            child: Icon(Icons.account_balance, size: 16, color: AppColors.primary),
          ),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.68),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: _fromCitizen ? const Color(0xFFE8E0FF) : AppColors.surface,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(18),
                topRight: const Radius.circular(18),
                bottomLeft: _fromCitizen ? const Radius.circular(18) : const Radius.circular(4),
                bottomRight: _fromCitizen ? const Radius.circular(4) : const Radius.circular(18),
              ),
            ),
            child: Column(
              crossAxisAlignment: _fromCitizen ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!_fromCitizen) ...[
                  Text('MLA Office', style: AppTextStyles.labelSmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                ],
                Text(msg.body, style: AppTextStyles.bodyMedium),
                const SizedBox(height: 4),
                Text(_fmtTime(msg.createdAt), style: AppTextStyles.caption),
              ],
            ),
          ),
        ),
        if (_fromCitizen) ...[
          const SizedBox(width: 8),
          const CircleAvatar(
            radius: 18,
            backgroundColor: Color(0xFFD8D0F5),
            child: Icon(Icons.person, size: 20, color: AppColors.primary),
          ),
        ],
      ],
    );
  }

  String _fmtTime(DateTime d) {
    final h = d.hour % 12 == 0 ? 12 : d.hour % 12;
    final m = d.minute.toString().padLeft(2, '0');
    final ampm = d.hour < 12 ? 'AM' : 'PM';
    return '$h:$m $ampm';
  }
}

class _NoThreadsState extends StatelessWidget {
  const _NoThreadsState({required this.onStart});
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(color: Color(0xFFD8D0F5), shape: BoxShape.circle),
              child: const Icon(Icons.chat_bubble_outline_rounded, size: 40, color: AppColors.primary),
            ),
            const SizedBox(height: 24),
            const Text('Start a conversation', style: AppTextStyles.titleLarge),
            const SizedBox(height: 12),
            const Text(
              'Send a message to the MLA office.\nWe\'ll get back to you soon.',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onStart,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Start Conversation'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InputBar extends StatelessWidget {
  const _InputBar({required this.controller});
  final ChatController controller;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 2))],
                ),
                child: TextField(
                  controller: controller.bodyController,
                  maxLines: 1,
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                  decoration: const InputDecoration(
                    hintText: 'Type your message…',
                    hintStyle: AppTextStyles.bodyMedium,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Obx(() => GestureDetector(
              onTap: controller.sending.value ? null : controller.send,
              child: AnimatedOpacity(
                opacity: controller.sending.value ? 0.5 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                  child: controller.sending.value
                      ? const Padding(padding: EdgeInsets.all(14), child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Icon(Icons.send_rounded, color: Colors.white, size: 22),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
