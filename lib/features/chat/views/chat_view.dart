import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/office_message_model.dart';
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
        actions: const [IconButton(icon: Icon(Icons.info_outline), onPressed: null)],
      ),
      body: Obx(() {
        if (auth.userId == null) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'Sign in with your phone number to send a message to the MLA office.',
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        return Column(
          children: [
            Expanded(
              child: Obx(() {
                if (controller.loading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.items.isEmpty) {
                  return const _EmptyState();
                }
                final msgs = controller.items;
                // Build flat list with date separator entries
                final List<({bool isDate, String? dateLabel, int? msgIndex})> rows = [];
                for (int i = 0; i < msgs.length; i++) {
                  final prev = i > 0 ? msgs[i - 1] : null;
                  final cur = msgs[i];
                  if (prev == null || !_sameDay(prev.createdAt, cur.createdAt)) {
                    rows.add((isDate: true, dateLabel: _fmtDate(cur.createdAt), msgIndex: null));
                  }
                  rows.add((isDate: false, dateLabel: null, msgIndex: i));
                }
                return ListView.builder(
                  controller: controller.scrollController,
                  reverse: true,
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  itemCount: rows.length,
                  itemBuilder: (_, i) {
                    final row = rows[rows.length - 1 - i];
                    if (row.isDate) {
                      return _DateSeparator(label: row.dateLabel!);
                    }
                    final m = msgs[row.msgIndex!];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: m.fromCitizen ? _CitizenBubble(message: m) : _OfficeBubble(message: m),
                    );
                  },
                );
              }),
            ),
            _InputBar(controller: controller),
          ],
        );
      }),
    );
  }

  static bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static String _fmtDate(DateTime d) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }
}

String _fmtTime(DateTime d) {
  final h = d.hour % 12 == 0 ? 12 : d.hour % 12;
  final m = d.minute.toString().padLeft(2, '0');
  final ampm = d.hour < 12 ? 'AM' : 'PM';
  return '$h:$m $ampm';
}

class _DateSeparator extends StatelessWidget {
  const _DateSeparator({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          const Expanded(child: Divider(color: Color(0xFFD0C8E8))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary)),
          ),
          const Expanded(child: Divider(color: Color(0xFFD0C8E8))),
        ],
      ),
    );
  }
}

class _CitizenBubble extends StatelessWidget {
  const _CitizenBubble({required this.message});
  final OfficeMessageModel message;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Flexible(
          child: Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.68),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFE8E0FF),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(4),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(message.body, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_fmtTime(message.createdAt), style: AppTextStyles.caption),
                    const SizedBox(width: 4),
                    Icon(Icons.done_all, size: 14, color: AppColors.primary),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        CircleAvatar(
          radius: 18,
          backgroundColor: const Color(0xFFD8D0F5),
          child: Icon(Icons.person, size: 20, color: AppColors.primary),
        ),
      ],
    );
  }
}

class _OfficeBubble extends StatelessWidget {
  const _OfficeBubble({required this.message});
  final OfficeMessageModel message;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: const Color(0xFFD8D0F5),
          child: Icon(Icons.account_balance, size: 16, color: AppColors.primary),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.68),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MLA Office',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 4),
                Text(message.body, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Text(_fmtTime(message.createdAt), style: AppTextStyles.caption),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 160,
              height: 160,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer glow circle
                  Container(
                    width: 140,
                    height: 140,
                    decoration: const BoxDecoration(color: Color(0xFFD8D0F5), shape: BoxShape.circle),
                  ),
                  // Chat bubble
                  CustomPaint(size: const Size(90, 82), painter: _BubblePainter()),
                  // Three dots
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [_dot(), const SizedBox(width: 6), _dot(), const SizedBox(width: 6), _dot()],
                  ),
                  // Decoration dots
                  Positioned(top: 18, right: 22, child: _sparkDot(10, AppColors.primary)),
                  Positioned(top: 8, left: 30, child: _sparkDot(6, const Color(0xFFB39DDB))),
                  Positioned(bottom: 20, left: 16, child: _sparkDot(7, const Color(0xFFB39DDB))),
                  Positioned(top: 32, left: 12, child: _sparkDot(4, AppColors.primary.withValues(alpha: 0.5))),
                  Positioned(bottom: 28, right: 14, child: _sparkDot(4, AppColors.primary.withValues(alpha: 0.5))),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Start a conversation',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Send a message to the MLA office.\nWe\'ll get back to you soon.',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _dot() => Container(
    width: 8,
    height: 8,
    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
  );

  Widget _sparkDot(double size, Color color) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );
}

class _BubblePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.primary;
    final radius = Radius.circular(size.height * 0.42);
    final tailH = size.height * 0.18;
    final bubbleRect = RRect.fromLTRBR(0, 0, size.width, size.height - tailH, radius);
    canvas.drawRRect(bubbleRect, paint);
    // Tail bottom-left
    final path = Path()
      ..moveTo(size.width * 0.18, size.height - tailH)
      ..lineTo(size.width * 0.08, size.height)
      ..lineTo(size.width * 0.38, size.height - tailH)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_BubblePainter old) => false;
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
                child: Row(
                  children: [
                    Expanded(
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
                    // const IconButton(
                    //   icon: Icon(Icons.attach_file_outlined, color: AppColors.primary),
                    //   onPressed: null,
                    // ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Obx(
              () => GestureDetector(
                onTap: controller.sending.value ? null : controller.send,
                child: AnimatedOpacity(
                  opacity: controller.sending.value ? 0.5 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                    child: controller.sending.value
                        ? const Padding(
                            padding: EdgeInsets.all(14),
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : const Icon(Icons.send_rounded, color: Colors.white, size: 22),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
