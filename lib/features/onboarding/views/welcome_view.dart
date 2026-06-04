import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../routes/app_routes.dart';
import '../controllers/onboarding_controller.dart';

class WelcomeView extends GetView<OnboardingController> {
  const WelcomeView({super.key});

  static const _slides = [
    _Slide(
      image: 'assets/images/welcome_issue.png',
      titleNormal: 'Raise ',
      titleColored: 'Issues',
      subtitle: 'Roads, water, waste & safety',
    ),
    _Slide(
      image: 'assets/images/shareidea.png',
      titleNormal: 'Share ',
      titleColored: 'Ideas',
      subtitle: 'Big ideas for the future of\nour constituency',
    ),
    _Slide(
      image: 'assets/images/improvements.png',
      titleNormal: 'Suggest ',
      titleColored: 'Improvements',
      subtitle: 'Practical improvements\nfor a better future',
    ),
    _Slide(
      image: 'assets/images/updates.png',
      titleNormal: 'Track ',
      titleColored: 'Updates',
      subtitle: 'Stay updated with\ndevelopments',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final pageController = PageController();
    final currentPage = 0.obs;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: Image.asset(
                      'assets/images/nameless_logo.png',
                      width: 36.r,
                      height: 36.r,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Obx(() {
                    final name = controller.savedConstituencyName.value;
                    return Text(
                      name.isNotEmpty ? name : 'MLA Connect',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    );
                  }),
                ],
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              AppStrings.welcomeSubtitle,
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),

            // Carousel
            Expanded(
              child: PageView.builder(
                controller: pageController,
                itemCount: _slides.length,
                onPageChanged: (i) => currentPage.value = i,
                itemBuilder: (_, i) => _SlideContent(slide: _slides[i]),
              ),
            ),

            // Dots
            Obx(() => _DotsIndicator(count: _slides.length, current: currentPage.value)),
            SizedBox(height: 24.h),

            // CTA
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: PrimaryButton(
                text: AppStrings.getStarted,
                onPressed: () => Get.toNamed(Routes.phone),
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.shield_outlined, size: 14.r, color: AppColors.grey500),
                SizedBox(width: 4.w),
                Text(
                  'Your information is safe and will never be shared.',
                  style: AppTextStyles.caption,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}

class _Slide {
  final String image;
  final String titleNormal;
  final String titleColored;
  final String subtitle;

  const _Slide({
    required this.image,
    required this.titleNormal,
    required this.titleColored,
    required this.subtitle,
  });
}

class _SlideContent extends StatelessWidget {
  final _Slide slide;
  const _SlideContent({required this.slide});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 30.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
              children: [
                TextSpan(text: slide.titleNormal),
                TextSpan(
                  text: slide.titleColored,
                  style: const TextStyle(color: AppColors.primary),
                ),
              ],
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            slide.subtitle,
            style: AppTextStyles.bodyMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.h),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: Image.asset(
                slide.image,
                width: double.infinity,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DotsIndicator extends StatelessWidget {
  final int count;
  final int current;
  const _DotsIndicator({required this.count, required this.current});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          width: active ? 20.w : 8.w,
          height: 8.h,
          decoration: BoxDecoration(
            color: active ? AppColors.primary : AppColors.grey300,
            borderRadius: BorderRadius.circular(4.r),
          ),
        );
      }),
    );
  }
}
