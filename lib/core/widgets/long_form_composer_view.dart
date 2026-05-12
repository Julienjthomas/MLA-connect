import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Full-screen editor sharing a [TextEditingController] with the caller.
class LongFormComposerView extends StatelessWidget {
  final TextEditingController textController;
  final String title;

  const LongFormComposerView({
    super.key,
    required this.textController,
    this.title = 'Write in detail',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: AppTextStyles.titleMedium),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Done')),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: TextField(
          controller: textController,
          autofocus: true,
          maxLines: null,
          expands: true,
          textAlignVertical: TextAlignVertical.top,
          maxLength: 1500,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Type here…',
          ),
        ),
      ),
    );
  }
}
