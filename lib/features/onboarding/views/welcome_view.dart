import 'package:flutter/material.dart';
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
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/images/nameless_logo.png',
                      width: 36,
                      height: 36,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Obx(() {
                    final name = controller.savedConstituencyName.value;
                    return Text(
                      name.isNotEmpty ? name : 'MLA Connect',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              AppStrings.welcomeSubtitle,
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

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
            const SizedBox(height: 24),

            // CTA
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: PrimaryButton(
                text: AppStrings.getStarted,
                onPressed: () => Get.toNamed(Routes.phone),
              ),
            ),
            const SizedBox(height: 12),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.shield_outlined, size: 14, color: AppColors.grey500),
                SizedBox(width: 4),
                Text(
                  'Your information is safe and will never be shared.',
                  style: AppTextStyles.caption,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const SizedBox(height: 20),
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
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 30,
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
          const SizedBox(height: 4),
          Text(
            slide.subtitle,
            style: AppTextStyles.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
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
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 20 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: active ? AppColors.primary : AppColors.grey300,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
