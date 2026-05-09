import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/mla_model.dart';
import '../../../routes/app_routes.dart';

class MlaHeroBanner extends StatelessWidget {
  final MlaModel mla;

  const MlaHeroBanner({super.key, required this.mla});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.mlaDetail),
      child: Container(
        height: 140,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [AppColors.primaryDark, AppColors.primary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Background landscape image
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Opacity(
                  opacity: 0.15,
                  child: CachedNetworkImage(
                    imageUrl: 'https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?w=800&q=80',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // MLA photo
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2.5),
                    ),
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: mla.photoUrl ?? '',
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => Container(
                          color: Colors.white24,
                          child: const Icon(Icons.person, color: Colors.white, size: 36),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(mla.name, style: AppTextStyles.titleLarge.copyWith(color: Colors.white)),
                            const SizedBox(width: 6),
                            const Icon(Icons.verified_rounded, color: Colors.white70, size: 16),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, color: Colors.white70, size: 13),
                            const SizedBox(width: 3),
                            Text(mla.constituency, style: AppTextStyles.caption.copyWith(color: Colors.white70)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            _stat('${mla.stats.issuesResolved}', 'Resolved'),
                            const SizedBox(width: 16),
                            _stat('${mla.stats.activeProjects}', 'Projects'),
                            const SizedBox(width: 16),
                            _stat('${mla.stats.ideasImplemented}', 'Ideas'),
                          ],
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
    );
  }

  Widget _stat(String value, String label) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.titleSmall.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
        Text(label, style: AppTextStyles.caption.copyWith(color: Colors.white60, fontSize: 9)),
      ],
    );
  }
}
