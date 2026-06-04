import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/kerala_app_bar.dart';
import '../../../core/widgets/primary_button.dart';
import '../controllers/profile_setup_controller.dart';

class ProfileSetupView extends GetView<ProfileSetupController> {
  const ProfileSetupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KeralaAppBar(title: AppStrings.basicProfile),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppStrings.basicProfile, style: AppTextStyles.headlineSmall),
                SizedBox(height: 4.h),
                Text(AppStrings.basicProfileSubtitle, style: AppTextStyles.bodySmall),
                SizedBox(height: 32.h),
                Center(
                  child: GestureDetector(
                    onTap: controller.pickAndUploadImage,
                    child: Obx(() {
                      final path = controller.pickedImagePath.value;
                      final uploading = controller.uploadingAvatar.value;
                      return Stack(
                        children: [
                          CircleAvatar(
                            radius: 44.r,
                            backgroundColor: AppColors.grey200,
                            backgroundImage: path.isNotEmpty ? FileImage(File(path)) : null,
                            child: path.isEmpty
                                ? Icon(Icons.person, size: 44.r, color: AppColors.grey500)
                                : null,
                          ),
                          if (uploading)
                            Positioned.fill(
                              child: CircleAvatar(
                                radius: 44.r,
                                backgroundColor: Colors.black38,
                                child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              ),
                            ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 30.r,
                              height: 30.r,
                              decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                              child: Icon(Icons.camera_alt, color: Colors.white, size: 16.r),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
                SizedBox(height: 28.h),
                TextFormField(
                  controller: controller.nameController,
                  validator: (v) => Validators.minLength(v, 2, 'Name'),
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person_outline, size: 20.r),
                    hintText: AppStrings.fullName,
                  ),
                ),
                SizedBox(height: 14.h),
                TextFormField(
                  controller: controller.emailController,
                  validator: Validators.email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email_outlined, size: 20.r),
                    hintText: AppStrings.emailOptional,
                  ),
                ),
                const Spacer(),
                Obx(
                  () => PrimaryButton(
                    text: AppStrings.next,
                    onPressed: controller.next,
                    isLoading: controller.loading.value,
                  ),
                ),
                SizedBox(height: 12.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
