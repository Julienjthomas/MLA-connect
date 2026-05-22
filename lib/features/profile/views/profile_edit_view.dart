import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/profile_edit_controller.dart';

class ProfileEditView extends GetView<ProfileEditController> {
  const ProfileEditView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        centerTitle: false,
        title: const Text('Edit Profile', style: AppTextStyles.titleLarge),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.divider),
        ),
        actions: [
          Obx(
            () => TextButton(
              onPressed: controller.loading.value ? null : controller.save,
              child: controller.loading.value
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text(
                      'Save',
                      style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                    ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 8),
              _AvatarPicker(controller: controller),
              const SizedBox(height: 32),
              TextFormField(
                controller: controller.nameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person_outline_rounded),
                ),
                validator: (v) {
                  if (v == null || v.trim().length < 2) return 'Name must be at least 2 characters';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email (optional)',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return null;
                  final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim());
                  return ok ? null : 'Enter a valid email address';
                },
              ),
              const SizedBox(height: 16),
              Obx(() {
                final user = Get.find<AuthController>().user.value;
                final phone = user?.phone;
                final localBody = user?.localBodyName;
                final ward = user?.wardName;
                return Column(
                  children: [
                    if (phone != null && phone.isNotEmpty) ...[
                      TextFormField(
                        initialValue: phone.startsWith('+') ? phone : '+91 $phone',
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          prefixIcon: Icon(Icons.phone_outlined),
                        ),
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (localBody != null) ...[
                      TextFormField(
                        initialValue: localBody,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Panchayat / Local Body',
                          prefixIcon: Icon(Icons.location_city_outlined),
                        ),
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (ward != null) ...[
                      TextFormField(
                        initialValue: ward,
                        readOnly: true,
                        decoration: const InputDecoration(labelText: 'Ward', prefixIcon: Icon(Icons.map_outlined)),
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ],
                );
              }),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _AvatarPicker extends StatelessWidget {
  final ProfileEditController controller;
  const _AvatarPicker({required this.controller});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: controller.pickAndUploadAvatar,
      child: Obx(() {
        final localPath = controller.pickedImagePath.value;
        final networkUrl = controller.avatarUrl.value;
        final uploading = controller.uploadingAvatar.value;

        Widget image;
        if (localPath.isNotEmpty) {
          image = Image.file(File(localPath), fit: BoxFit.cover);
        } else if (networkUrl.isNotEmpty) {
          image = CachedNetworkImage(
            imageUrl: networkUrl,
            fit: BoxFit.cover,
            errorWidget: (_, __, ___) => _initials(controller),
          );
        } else {
          image = _initials(controller);
        }

        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surfaceVariant,
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 2),
              ),
              child: ClipOval(child: image),
            ),
            if (uploading)
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black.withValues(alpha: 0.4)),
                child: const Center(child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
              ),
            if (!uploading)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primary),
                  child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 16),
                ),
              ),
          ],
        );
      }),
    );
  }

  Widget _initials(ProfileEditController c) {
    final name = c.nameController.text;
    final initials = name.trim().split(' ').map((w) => w.isNotEmpty ? w[0] : '').take(2).join().toUpperCase();
    return Container(
      color: AppColors.surfaceVariant,
      child: Center(
        child: Text(
          initials.isEmpty ? 'U' : initials,
          style: AppTextStyles.titleLarge.copyWith(color: AppColors.primary),
        ),
      ),
    );
  }
}
