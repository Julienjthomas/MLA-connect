import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_enums.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/linkable_text.dart';
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
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppColors.background,
            foregroundColor: AppColors.textPrimary,
            leading: Padding(
              padding: EdgeInsets.all(8.r),
              child: Material(
                color: AppColors.surface.withValues(alpha: 0.7),
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => Get.back(),
                  child: SizedBox(
                    width: 40.r,
                    height: 40.r,
                    child: Icon(Icons.arrow_back_rounded, color: Colors.black, size: 20.r),
                  ),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: update.imageUrl ?? '',
                    cacheKey: update.imageCacheKey,
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => Container(
                      color: AppColors.ideaPurpleLight,
                      child: Center(
                        child: Icon(
                          Icons.campaign_rounded,
                          size: 64.r,
                          color: update.category.color.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  ),
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
            ),
            actions: const [],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CategoryChip(label: update.category.label, color: update.category.color),
                  SizedBox(height: 12.h),
                  Text(update.title, style: AppTextStyles.headlineMedium),
                  SizedBox(height: 8.h),
                  Text(update.timeAgo, style: AppTextStyles.caption),
                  SizedBox(height: 20.h),
                  LinkableText(text: update.localBody, style: AppTextStyles.bodyLarge),
                  SizedBox(height: 24.h),
                  Obx(() {
                    final liked = controller.likedIds.contains(update.id);
                    final current = controller.updates.firstWhereOrNull((u) => u.id == update.id);
                    final likes = current?.likes ?? update.likes;
                    return Row(
                      children: [
                        GestureDetector(
                          onTap: () => controller.toggleLike(update.id),
                          child: Row(
                            children: [
                              Icon(
                                liked ? Icons.favorite : Icons.favorite_outline,
                                size: 16.r,
                                color: AppColors.statusRejected,
                              ),
                              SizedBox(width: 4.w),
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
