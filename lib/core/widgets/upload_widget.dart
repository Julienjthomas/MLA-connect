import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class UploadWidget extends StatelessWidget {
  final List<XFile> files;
  final Function(List<XFile>) onChanged;
  final String label;
  final int maxFiles;

  const UploadWidget({
    super.key,
    required this.files,
    required this.onChanged,
    this.label = 'Add Photos / Videos (Optional)',
    this.maxFiles = 5,
  });

  Future<void> _pick() async {
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage(limit: maxFiles - files.length);
    if (picked.isNotEmpty) {
      onChanged([...files, ...picked]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.titleSmall),
        const SizedBox(height: 10),
        if (files.isEmpty)
          GestureDetector(
            onTap: _pick,
            child: DottedBorder(
              borderType: BorderType.RRect,
              radius: const Radius.circular(12),
              color: AppColors.grey400,
              strokeWidth: 1.5,
              dashPattern: const [6, 4],
              child: Container(
                height: 90,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.grey50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add_photo_alternate_outlined, color: AppColors.grey400, size: 28),
                    const SizedBox(height: 6),
                    Text('Tap to add photos', style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
            ),
          )
        else
          SizedBox(
            height: 90,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ...files.asMap().entries.map((e) => _imageThumb(e.value, e.key)),
                if (files.length < maxFiles) _addMore(),
              ],
            ),
          ),
      ],
    );
  }

  Widget _imageThumb(XFile file, int index) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 8),
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: FileImage(File(file.path)),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 12,
          child: GestureDetector(
            onTap: () {
              final updated = [...files]..removeAt(index);
              onChanged(updated);
            },
            child: Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
              child: const Icon(Icons.close, color: Colors.white, size: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _addMore() {
    return GestureDetector(
      onTap: _pick,
      child: Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          color: AppColors.grey100,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.grey300),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: AppColors.grey500, size: 24),
            SizedBox(height: 2),
            Text('Add More', style: TextStyle(fontSize: 10, color: AppColors.grey500)),
          ],
        ),
      ),
    );
  }
}
