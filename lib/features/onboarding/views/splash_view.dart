import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../features/auth/controllers/auth_controller.dart';
import '../../../routes/app_routes.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _scaleAnim = Tween<double>(begin: 0.85, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _animController.forward();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 2000));
    final auth = Get.find<AuthController>();
    if (auth.isLoggedIn) {
      final hasProfile = await auth.hasCompletedOnboarding();
      if (hasProfile) {
        Get.offAllNamed(Routes.home);
      } else {
        Get.offAllNamed(Routes.panchayat);
      }
    } else {
      Get.offAllNamed(Routes.welcome);
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: ScaleTransition(
            scale: _scaleAnim,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 8))],
                  ),
                  child: const Icon(Icons.rocket_launch_rounded, color: AppColors.primary, size: 52),
                ),
                const SizedBox(height: 24),
                RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(children: [
                    TextSpan(text: 'Super ', style: TextStyle(fontFamily: 'Poppins', fontSize: 32, fontWeight: FontWeight.w700, color: Colors.white)),
                    TextSpan(text: 'Balussery', style: TextStyle(fontFamily: 'Poppins', fontSize: 32, fontWeight: FontWeight.w300, color: Colors.white70)),
                  ]),
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
    );
  }
}
