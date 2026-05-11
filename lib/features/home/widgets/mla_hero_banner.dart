import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        height: 130,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFF3A5BA0), Color(0xFF5B82D4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Background landscape image — reduced opacity
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Opacity(
                  opacity: 0.08,
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
                    width: 68,
                    height: 68,
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
                          child: const Icon(Icons.person, color: Colors.white, size: 34),
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
                        Text(
                          'MLA',
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.white60,
                            fontSize: 11,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          mla.name,
                          style: AppTextStyles.titleLarge.copyWith(
                            color: Colors.white,
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          mla.constituency,
                          style: AppTextStyles.caption.copyWith(color: Colors.white70),
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
}
