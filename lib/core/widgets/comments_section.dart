import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../features/auth/controllers/auth_controller.dart';

/// Generic comment entry used by concern/idea/appreciation detail screens.
class CommentEntry {
  const CommentEntry({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.body,
    required this.createdAt,
    this.avatarUrl,
  });
  final String id;
  final String authorId;
  final String authorName;
  final String body;
  final DateTime createdAt;
  final String? avatarUrl;
}

/// Drop-in comments widget. Supply [onLoad], [onPost], [onDelete] callbacks.
class CommentsSection extends StatefulWidget {
  const CommentsSection({
    super.key,
    required this.onLoad,
    required this.onPost,
    required this.onDelete,
  });

  final Future<List<CommentEntry>> Function() onLoad;
  final Future<void> Function(String text) onPost;
  final Future<void> Function(String commentId) onDelete;

  @override
  State<CommentsSection> createState() => _CommentsSectionState();
}

class _CommentsSectionState extends State<CommentsSection> {
  bool _expanded = false;
  bool _loading = false;
  bool _posting = false;
  List<CommentEntry> _comments = [];
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      _comments = await widget.onLoad();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _post() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() => _posting = true);
    try {
      await widget.onPost(text);
      _controller.clear();
      _focusNode.unfocus();
      await _load();
    } finally {
      if (mounted) setState(() => _posting = false);
    }
  }

  Future<void> _delete(CommentEntry comment) async {
    final ok = await Get.dialog<bool>(AlertDialog(
      title: const Text('Delete comment?'),
      content: const Text('This cannot be undone.'),
      actions: [
        TextButton(onPressed: () => Get.back(result: false), child: const Text('Cancel')),
        TextButton(
          onPressed: () => Get.back(result: true),
          child: const Text('Delete', style: TextStyle(color: AppColors.statusRejected)),
        ),
      ],
    ));
    if (ok == true) {
      await widget.onDelete(comment.id);
      await _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 1),
        InkWell(
          onTap: () {
            setState(() => _expanded = !_expanded);
            if (_expanded && _comments.isEmpty) _load();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                const Icon(Icons.comment_outlined, size: 18, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  _expanded ? 'Hide comments' : 'View comments${_comments.isNotEmpty ? " (${_comments.length})" : ""}',
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                Icon(_expanded ? Icons.expand_less : Icons.expand_more, size: 20, color: AppColors.grey400),
              ],
            ),
          ),
        ),
        if (_expanded) ...[
          if (_loading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            )
          else if (_comments.isEmpty)
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Text('No comments yet.', style: AppTextStyles.bodySmall),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _comments.length,
              separatorBuilder: (_, __) => const Divider(height: 1, indent: 56),
              itemBuilder: (_, i) => _CommentTile(
                comment: _comments[i],
                onDelete: _delete,
              ),
            ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    minLines: 1,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Write a comment...',
                      hintStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.textHint),
                      filled: true,
                      fillColor: AppColors.surfaceVariant,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: AppTextStyles.bodySmall,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _posting ? null : _post,
                  child: AnimatedOpacity(
                    opacity: _posting ? 0.5 : 1,
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                      child: _posting
                          ? const Padding(padding: EdgeInsets.all(10), child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _CommentTile extends StatelessWidget {
  const _CommentTile({required this.comment, required this.onDelete});
  final CommentEntry comment;
  final Future<void> Function(CommentEntry) onDelete;

  @override
  Widget build(BuildContext context) {
    final currentUserId = Get.isRegistered<AuthController>()
        ? Get.find<AuthController>().userId
        : null;
    final isOwn = currentUserId == comment.authorId;

    return GestureDetector(
      onLongPress: isOwn ? () => onDelete(comment) : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.surfaceVariant,
              child: Text(
                comment.authorName.isNotEmpty ? comment.authorName[0].toUpperCase() : 'U',
                style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(comment.authorName, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(width: 8),
                      Text(_timeAgo(comment.createdAt), style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary)),
                      if (isOwn) ...[
                        const Spacer(),
                        const Icon(Icons.more_horiz, size: 16, color: AppColors.grey400),
                      ],
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(comment.body, style: AppTextStyles.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m';
    if (diff.inDays < 1) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }
}
