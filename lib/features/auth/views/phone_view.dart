import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/kerala_app_bar.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../routes/app_routes.dart';
import '../controllers/auth_controller.dart';

class PhoneView extends StatefulWidget {
  const PhoneView({super.key});

  @override
  State<PhoneView> createState() => _PhoneViewState();
}

class _PhoneViewState extends State<PhoneView> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await Get.find<AuthController>().sendOtp(_phoneController.text.trim());
      Get.toNamed(Routes.otp, arguments: _phoneController.text.trim());
    } catch (e) {
      Get.snackbar('Error', 'Failed to send OTP. Please try again.',
          backgroundColor: AppColors.statusRejected, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const KeralaAppBar(title: ''),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                Text(AppStrings.enterMobile, style: AppTextStyles.headlineLarge),
                const SizedBox(height: 8),
                Text(AppStrings.mobileSubtitle, style: AppTextStyles.bodyMedium),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                  validator: Validators.phone,
                  decoration: InputDecoration(
                    prefixIcon: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.grey100,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.grey300),
                      ),
                      child: Text('+91', style: AppTextStyles.titleSmall),
                    ),
                    hintText: 'Enter 10 digit mobile number',
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.shield_outlined, size: 14, color: AppColors.textTertiary),
                    const SizedBox(width: 6),
                    Text(AppStrings.privacyNote, style: AppTextStyles.caption),
                  ],
                ),
                const Spacer(),
                PrimaryButton(text: AppStrings.sendOtp, onPressed: _sendOtp, isLoading: _loading),
                const SizedBox(height: 12),
                Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: AppTextStyles.caption,
                      children: [
                        const TextSpan(text: 'By continuing, you agree to our '),
                        TextSpan(
                          text: 'Terms & Privacy Policy',
                          style: AppTextStyles.caption.copyWith(color: AppColors.primary, decoration: TextDecoration.underline),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
