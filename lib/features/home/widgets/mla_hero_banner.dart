import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/mla_model.dart';
import '../../../routes/app_routes.dart';

class MlaHeroBanner extends StatelessWidget {
  const MlaHeroBanner({super.key, required this.mla});
  final MlaModel mla;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.mlaDetail),
      child: Container(
        height: 120.h,
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(color: const Color(0xFFF0EEFF), borderRadius: BorderRadius.circular(20.r)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: Stack(
            children: [
              // Dot grid — top right
              Positioned(top: 0, right: 15, child: _DotGrid()),
              // Purple blob — bottom right
              Positioned(
                bottom: -60,
                right: -60,
                child: Container(
                  width: 100.r,
                  height: 100.r,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF7C54E8), AppColors.primary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              // Content row
              Padding(
                padding: EdgeInsets.fromLTRB(12.w, 16.h, 16.w, 16.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Photo with blue arc
                    _PhotoWithArc(photoUrl: mla.photoUrl),
                    SizedBox(width: 16.w),
                    // Text
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            mla.name,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                              height: 1.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 6.h),
                          Container(
                            width: 24.w,
                            height: 1,
                            decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(2.r)),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Your Voice. Our Commitment.',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PhotoWithArc extends StatelessWidget {
  const _PhotoWithArc({required this.photoUrl});
  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110.w,
      height: 128.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Blue arc behind photo
          CustomPaint(size: Size(110.w, 128.h), painter: _ArcPainter()),
          // Photo circle
          Positioned(
            top: 8,
            child: Container(
              width: 96.r,
              height: 96.r,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: ClipOval(
                child: photoUrl != null && photoUrl!.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: photoUrl!,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => _placeholder(),
                      )
                    : _placeholder(),
              ),
            ),
          ),
          // Small purple dot bottom-left
          Positioned(
            bottom: 4,
            left: 12,
            child: Container(
              width: 12.r,
              height: 12.r,
              decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() => Container(
    color: const Color(0xFFD8D0F5),
    child: Icon(Icons.person, color: AppColors.primary, size: 40.r),
  );
}

class _ArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2 - 8);
    const radius = 52.0;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      3.4,
      1.8,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_ArcPainter old) => false;
}

class _DotGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50.w,
      height: 40.h,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 6,
          crossAxisSpacing: 6,
        ),
        itemCount: 16,
        itemBuilder: (_, __) => Container(
          decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.18), shape: BoxShape.circle),
        ),
      ),
    );
  }
}
