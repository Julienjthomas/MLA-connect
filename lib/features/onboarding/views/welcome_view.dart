import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../routes/app_routes.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 32),
              // Logo
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.rocket_launch_rounded, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 10),
                  RichText(
                    text: const TextSpan(children: [
                      TextSpan(text: 'Super ', style: TextStyle(fontFamily: 'Poppins', fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.primary)),
                      TextSpan(text: 'Balussery', style: TextStyle(fontFamily: 'Poppins', fontSize: 22, fontWeight: FontWeight.w400, color: AppColors.textPrimary)),
                    ]),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(AppStrings.welcomeSubtitle, style: AppTextStyles.bodySmall, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              // Hero image
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl: AppAssets.balusseryLandscape,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => Container(
                    height: 180,
                    color: AppColors.surfaceVariant,
                    child: const Icon(Icons.image_outlined, size: 48, color: AppColors.grey400),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              // Feature list
              _featureItem(Icons.warning_amber_rounded, AppColors.reportOrange, 'Report Problems', 'Roads, water, waste, safety & more'),
              const SizedBox(height: 14),
              _featureItem(Icons.favorite_rounded, AppColors.appreciateGreen, 'Appreciate Good Work', 'Recognize staff or projects'),
              const SizedBox(height: 14),
              _featureItem(Icons.lightbulb_rounded, AppColors.ideaPurple, 'Suggest Improvements', 'Share ideas for a better future'),
              const SizedBox(height: 14),
              _featureItem(Icons.track_changes_rounded, AppColors.improveBlue, 'Track Updates', 'Stay updated with developments'),
              const Spacer(),
              PrimaryButton(
                text: AppStrings.continueWithPhone,
                onPressed: () => Get.toNamed(Routes.language),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Get.toNamed(Routes.home),
                child: Text(
                  AppStrings.browsePublicUpdates,
                  style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _featureItem(IconData icon, Color color, String title, String subtitle) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.titleSmall.copyWith(color: color)),
              Text(subtitle, style: AppTextStyles.caption),
            ],
          ),
        ),
      ],
    );
  }
}
