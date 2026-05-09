import 'package:flutter/material.dart';
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
      appBar: const KeralaAppBar(title: AppStrings.basicProfile),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(AppStrings.basicProfile, style: AppTextStyles.headlineSmall),
                const SizedBox(height: 4),
                const Text(AppStrings.basicProfileSubtitle, style: AppTextStyles.bodySmall),
                const SizedBox(height: 32),
                Center(
                  child: Stack(
                    children: [
                      const CircleAvatar(
                        radius: 44,
                        backgroundColor: AppColors.grey200,
                        child: Icon(Icons.person, size: 44, color: AppColors.grey500),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                TextFormField(
                  controller: controller.nameController,
                  validator: (v) => Validators.minLength(v, 2, 'Name'),
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person_outline, size: 20),
                    hintText: AppStrings.fullName,
                  ),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: controller.emailController,
                  validator: Validators.email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email_outlined, size: 20),
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
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
