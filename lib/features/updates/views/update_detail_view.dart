import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_enums.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/status_chip.dart';
import '../controllers/updates_controller.dart';

class UpdateDetailView extends GetView<UpdatesController> {
  const UpdateDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final id = Get.arguments as String?;
    final update = controller.updates.firstWhereOrNull((u) => u.id == id);
    if (update == null) return const Scaffold(body: Center(child: Text('Not found')));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (id != null) controller.incrementView(id);
    });

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: update.imageUrl != null ? 280 : kToolbarHeight,
            pinned: true,
            backgroundColor: AppColors.background,
            foregroundColor: AppColors.textPrimary,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: Material(
                color: AppColors.surface.withValues(alpha: 0.7),
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => Get.back(),
                  child: const SizedBox(
                    width: 40,
                    height: 40,
                    child: Icon(Icons.arrow_back_rounded, color: Colors.black, size: 20),
                  ),
                ),
              ),
            ),
            flexibleSpace: update.imageUrl != null
                ? FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        CachedNetworkImage(imageUrl: update.imageUrl!, cacheKey: update.imageCacheKey, fit: BoxFit.cover),
                        // Top gradient ensures back chip + status icons readable on dark images.
                        const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0x66000000), Color(0x00000000)],
                              stops: [0.0, 0.45],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : null,
            actions: const [],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CategoryChip(label: update.category.label, color: update.category.color),
                  const SizedBox(height: 12),
                  Text(update.title, style: AppTextStyles.headlineMedium),
                  const SizedBox(height: 8),
                  Text(update.timeAgo, style: AppTextStyles.caption),
                  const SizedBox(height: 20),
                  Text(update.body, style: AppTextStyles.bodyLarge),
                  const SizedBox(height: 24),
                  // Engagement row
                  Obx(() {
                    final liked = controller.likedIds.contains(update.id);
                    final current = controller.updates.firstWhereOrNull((u) => u.id == update.id);
                    final likes = current?.likes ?? update.likes;
                    return Row(
                      children: [
                        const Icon(Icons.visibility_outlined, size: 16, color: AppColors.grey500),
                        const SizedBox(width: 4),
                        Text('${update.views} views', style: AppTextStyles.caption),
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap: () => controller.toggleLike(update.id),
                          child: Row(
                            children: [
                              Icon(
                                liked ? Icons.favorite : Icons.favorite_outline,
                                size: 16,
                                color: AppColors.statusRejected,
                              ),
                              const SizedBox(width: 4),
                              Text('$likes likes', style: AppTextStyles.caption),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
