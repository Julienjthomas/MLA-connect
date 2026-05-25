import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../features/auth/controllers/auth_controller.dart';
import '../../../routes/app_routes.dart';

class OnboardingSuccessView extends StatelessWidget {
  const OnboardingSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                width: 96,
                height: 96,
                decoration: const BoxDecoration(color: AppColors.appreciateGreen, shape: BoxShape.circle),
                child: const Icon(Icons.check_rounded, color: Colors.white, size: 56),
              ),
              const SizedBox(height: 24),
              Text(AppStrings.allSet, style: AppTextStyles.headlineLarge, textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(AppStrings.allSetSubtitle, style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
              const SizedBox(height: 32),
              Obx(() {
                final user = auth.user.value;
                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    children: [
                      _infoRow(Icons.location_on_outlined, 'Local Body', user?.localBodyName ?? '–'),
                      const SizedBox(height: 12),
                      _infoRow(Icons.map_outlined, 'Ward', user?.wardName ?? '–'),
                    ],
                  ),
                );
              }),
              const Spacer(),
              PrimaryButton(
                text: AppStrings.goToHome,
                onPressed: () => Get.offAllNamed(Routes.home),
                backgroundColor: AppColors.appreciateGreen,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textTertiary),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.caption),
            Text(value, style: AppTextStyles.titleSmall),
          ],
        ),
      ],
    );
  }
}
