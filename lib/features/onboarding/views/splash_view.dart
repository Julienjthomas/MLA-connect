import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: AnimatedBuilder(
          animation: controller.animController,
          builder: (_, __) => FadeTransition(
            opacity: controller.fadeAnim,
            child: ScaleTransition(
              scale: controller.scaleAnim,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.rocket_launch_rounded, color: AppColors.primary, size: 52),
                  ),
                  const SizedBox(height: 24),
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Super ',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        TextSpan(
                          text: 'Balussery',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 32,
                            fontWeight: FontWeight.w300,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your voice. Our responsibility.',
                    style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70),
                  ),
                  const SizedBox(height: 48),
                  Text(
                    'Powered for\nBalussery Constituency',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.caption.copyWith(color: Colors.white54),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
