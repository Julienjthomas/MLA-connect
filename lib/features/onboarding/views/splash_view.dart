import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
                    width: 96.r,
                    height: 96.r,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(24.r),
                        child: Image.asset('assets/images/nameless_logo.png', width: 96.r, height: 96.r, fit: BoxFit.cover),
                      ),
                  ),
                  SizedBox(height: 24.h),
                  Obx(() {
                    final name = controller.constituencyName.value;
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          name.isNotEmpty ? name : 'MLA Connect',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 32.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        if (name.isNotEmpty) ...[
                          SizedBox(height: 8.h),
                          Text(
                            'MLA Connect',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70),
                          ),
                        ],
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
