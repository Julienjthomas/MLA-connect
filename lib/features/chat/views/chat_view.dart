import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          return Center(
            child: Padding(
              padding: EdgeInsets.all(24.r),
              child: const Text('Sign in to chat with the MLA office.', style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
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
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
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
              Icon(Icons.chat_bubble_outline_rounded, size: 48.r, color: AppColors.grey300),
              SizedBox(height: 12.h),
              const Text('No messages yet.', style: AppTextStyles.bodyMedium),
              SizedBox(height: 6.h),
              const Text('Send a message to start the conversation.', style: AppTextStyles.bodySmall),
            ],
          ),
        );
      }
      return ListView.builder(
        controller: controller.scrollController,
        padding: EdgeInsets.all(16.r),
        itemCount: msgs.length,
        itemBuilder: (_, i) => Padding(
          padding: EdgeInsets.only(bottom: 12.h),
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
          CircleAvatar(
            radius: 18.r,
            backgroundColor: const Color(0xFFD8D0F5),
            child: Icon(Icons.account_balance, size: 16.r, color: AppColors.primary),
          ),
          SizedBox(width: 8.w),
        ],
        Flexible(
          child: Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.68),
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: _fromCitizen ? const Color(0xFFE8E0FF) : AppColors.surface,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18.r),
                topRight: Radius.circular(18.r),
                bottomLeft: _fromCitizen ? Radius.circular(18.r) : Radius.circular(4.r),
                bottomRight: _fromCitizen ? Radius.circular(4.r) : Radius.circular(18.r),
              ),
            ),
            child: Column(
              crossAxisAlignment: _fromCitizen ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!_fromCitizen) ...[
                  Text('MLA Office', style: AppTextStyles.labelSmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)),
                  SizedBox(height: 4.h),
                ],
                Text(msg.body, style: AppTextStyles.bodyMedium),
                SizedBox(height: 4.h),
                Text(_fmtTime(msg.createdAt), style: AppTextStyles.caption),
              ],
            ),
          ),
        ),
        if (_fromCitizen) ...[
          SizedBox(width: 8.w),
          CircleAvatar(
            radius: 18.r,
            backgroundColor: const Color(0xFFD8D0F5),
            child: Icon(Icons.person, size: 20.r, color: AppColors.primary),
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
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80.r,
              height: 80.r,
              decoration: const BoxDecoration(color: Color(0xFFD8D0F5), shape: BoxShape.circle),
              child: Icon(Icons.chat_bubble_outline_rounded, size: 40.r, color: AppColors.primary),
            ),
            SizedBox(height: 24.h),
            const Text('Start a conversation', style: AppTextStyles.titleLarge),
            SizedBox(height: 12.h),
            const Text(
              'Send a message to the MLA office.\nWe\'ll get back to you soon.',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: onStart,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Start Conversation'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: const StadiumBorder(),
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
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
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 12.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(30.r),
                  boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 2))],
                ),
                child: TextField(
                  controller: controller.bodyController,
                  maxLines: 1,
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Type your message…',
                    hintStyle: AppTextStyles.bodyMedium,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Obx(() => GestureDetector(
              onTap: controller.sending.value ? null : controller.send,
              child: AnimatedOpacity(
                opacity: controller.sending.value ? 0.5 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  width: 50.r,
                  height: 50.r,
                  decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                  child: controller.sending.value
                      ? Padding(padding: EdgeInsets.all(14.r), child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Icon(Icons.send_rounded, color: Colors.white, size: 22.r),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
