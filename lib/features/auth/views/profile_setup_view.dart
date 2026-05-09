import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/kerala_app_bar.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../features/onboarding/controllers/onboarding_controller.dart';
import '../../../routes/app_routes.dart';
import '../controllers/auth_controller.dart';

class ProfileSetupView extends StatefulWidget {
  const ProfileSetupView({super.key});

  @override
  State<ProfileSetupView> createState() => _ProfileSetupViewState();
}

class _ProfileSetupViewState extends State<ProfileSetupView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _next() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final onboarding = Get.find<OnboardingController>();
      await Get.find<AuthController>().saveProfile(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        panchayatId: onboarding.selectedPanchayat.value!.id,
        wardId: onboarding.selectedWard.value!.id,
        language: onboarding.selectedLanguage.value,
      );
      Get.toNamed(Routes.notificationsSetup);
    } catch (e) {
      Get.snackbar('Error', 'Failed to save profile. Please try again.',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const KeralaAppBar(title: AppStrings.basicProfile),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppStrings.basicProfile, style: AppTextStyles.headlineSmall),
                const SizedBox(height: 4),
                Text(AppStrings.basicProfileSubtitle, style: AppTextStyles.bodySmall),
                const SizedBox(height: 32),
                // Avatar
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 44,
                        backgroundColor: AppColors.grey200,
                        child: const Icon(Icons.person, size: 44, color: AppColors.grey500),
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
                  controller: _nameController,
                  validator: (v) => Validators.minLength(v, 2, 'Name'),
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person_outline, size: 20),
                    hintText: AppStrings.fullName,
                  ),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _emailController,
                  validator: Validators.email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email_outlined, size: 20),
                    hintText: AppStrings.emailOptional,
                  ),
                ),
                const Spacer(),
                PrimaryButton(text: AppStrings.next, onPressed: _next, isLoading: _loading),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
