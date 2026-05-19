import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color accentColor;
  final VoidCallback onTap;
  final double? tileSize;
  final String? backgroundImage;

  const ActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.onTap,
    this.tileSize,
    this.backgroundImage,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 10, offset: const Offset(0, 3)),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Background image + gradient in lower portion
            if (backgroundImage != null)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: 110,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      backgroundImage!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(color: accentColor.withValues(alpha: 0.08)),
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0.0, 0.45, 1.0],
                          colors: [
                            AppColors.surface,
                            AppColors.surface.withValues(alpha: 0.75),
                            accentColor.withValues(alpha: 0.15),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Card content
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Circular icon container
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(color: accentColor.withValues(alpha: 0.15), shape: BoxShape.circle),
                    child: Icon(icon, color: accentColor, size: 22),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    style: AppTextStyles.titleLarge.copyWith(
                      color: accentColor,
                      height: 1.15,
                      shadows: const [
                        Shadow(color: Colors.white, blurRadius: 8, offset: Offset(0, 0)),
                        Shadow(color: Colors.white, blurRadius: 12, offset: Offset(0, 0)),
                      ],
                    ),
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                  const SizedBox(height: 4),
                  // Accent underline bar
                  Container(
                    width: 24,
                    height: 3,
                    decoration: BoxDecoration(color: accentColor, borderRadius: BorderRadius.circular(2)),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: AppTextStyles.caption.copyWith(height: 1.2, color: AppColors.textSecondary),
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                ],
              ),
            ),

            // Circular arrow CTA — bottom right over image zone
            Positioned(
              right: 12,
              bottom: 12,
              child: GestureDetector(
                onTap: onTap,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
                  ),
                  child: Icon(Icons.arrow_forward_rounded, color: accentColor, size: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
