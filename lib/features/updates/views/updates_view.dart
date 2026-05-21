import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_enums.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/shimmer_loader.dart';
import '../../../core/widgets/status_chip.dart';
import '../../../routes/app_routes.dart';
import '../../../data/models/update_model.dart';
import '../controllers/updates_controller.dart';

// Categories shown in filter row (resolved & others excluded)
const _filterCategories = [
  UpdateCategory.all,
  UpdateCategory.development,
  UpdateCategory.events,
  UpdateCategory.announcements,
];

class UpdatesView extends GetView<UpdatesController> {
  const UpdatesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        automaticallyImplyLeading: false,
        leadingWidth: 0,
        centerTitle: false,
        leading: const SizedBox.shrink(),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppStrings.updates, style: AppTextStyles.titleLarge),
            Text(AppStrings.stayUpdated, style: AppTextStyles.caption),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.divider),
        ),
      ),
      body: Obx(() {
        if (controller.loading.value) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: 4,
            itemBuilder: (_, __) => const ShimmerCard(),
          );
        }
        if (controller.error.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    controller.error.value,
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  TextButton(onPressed: controller.loadUpdates, child: const Text('Retry')),
                ],
              ),
            ),
          );
        }

        final featured = controller.featuredUpdates;
        final items = controller.filteredUpdates;

        return RefreshIndicator(
          onRefresh: controller.loadUpdates,
          child: CustomScrollView(
            slivers: [
              // Featured carousel
              if (featured.isNotEmpty) SliverToBoxAdapter(child: _FeaturedCarousel(items: featured)),

              // Filter chips
              SliverToBoxAdapter(child: _FilterRow()),

              // Feed
              if (items.isEmpty)
                const SliverFillRemaining(
                  child: EmptyState(title: 'No updates', message: 'No updates for this category yet.'),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  sliver: SliverList.builder(
                    itemCount: items.length,
                    itemBuilder: (_, i) => _UpdateCard(update: items[i]),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}

// ── Featured Carousel ────────────────────────────────────────────────────────

class _FeaturedCarousel extends StatefulWidget {
  final List<UpdateModel> items;
  const _FeaturedCarousel({required this.items});

  @override
  State<_FeaturedCarousel> createState() => _FeaturedCarouselState();
}

class _FeaturedCarouselState extends State<_FeaturedCarousel> {
  final _pageController = PageController();
  int _current = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 220,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.items.length,
            onPageChanged: (i) => setState(() => _current = i),
            itemBuilder: (_, i) => _FeaturedCard(update: widget.items[i]),
          ),
        ),
        if (widget.items.length > 1) ...[
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.items.length, (i) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: _current == i ? 20 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: _current == i ? AppColors.primary : AppColors.grey300,
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          ),
          const SizedBox(height: 4),
        ],
      ],
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  final UpdateModel update;
  const _FeaturedCard({required this.update});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.updateDetail, arguments: update.id),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        decoration: BoxDecoration(color: AppColors.textPrimary, borderRadius: BorderRadius.circular(20)),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            if (update.imageUrl != null)
              CachedNetworkImage(
                imageUrl: update.imageUrl!,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => Container(color: AppColors.primaryDark),
              ),
            // Gradient overlay
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withValues(alpha: 0.3), Colors.black.withValues(alpha: 0.75)],
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Featured badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star_rounded, size: 12, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          'Featured',
                          style: AppTextStyles.labelSmall.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    update.localTitle,
                    style: AppTextStyles.titleLarge.copyWith(color: Colors.white, fontSize: 18),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Spacer(),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, size: 12, color: Colors.white70),
                      const SizedBox(width: 4),
                      Text(update.timeAgo, style: AppTextStyles.caption.copyWith(color: Colors.white70)),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          'View Details →',
                          style: AppTextStyles.labelSmall.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
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

// ── Filter Row ───────────────────────────────────────────────────────────────

class _FilterRow extends GetView<UpdatesController> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: Obx(
        () => ListView(
          controller: controller.filterScrollController,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          children: _filterCategories.map((cat) {
            final isSelected = controller.selectedCategory.value == cat;
            return GestureDetector(
              onTap: () => controller.selectCategory(cat),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isSelected ? AppColors.primary : AppColors.grey300),
                ),
                child: Text(
                  cat.label,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// ── Update Card ──────────────────────────────────────────────────────────────

class _UpdateCard extends StatelessWidget {
  final UpdateModel update;
  const _UpdateCard({required this.update});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<UpdatesController>();
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.updateDetail, arguments: update.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            if (update.imageUrl != null)
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: update.imageUrl!,
                  width: 110,
                  height: 120,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => Container(width: 110, height: 120, color: AppColors.grey200),
                ),
              ),
            // Text content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CategoryChip(label: update.category.label, color: update.category.color),
                    const SizedBox(height: 6),
                    Text(
                      update.localTitle,
                      style: AppTextStyles.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      update.shortBody,
                      style: AppTextStyles.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Obx(() {
                      final liked = ctrl.likedIds.contains(update.id);
                      final current = ctrl.updates.firstWhereOrNull((u) => u.id == update.id);
                      final likes = current?.likes ?? update.likes;
                      final views = current?.views ?? update.views;
                      return Row(
                        children: [
                          Text(update.timeAgo, style: AppTextStyles.caption),
                          const Spacer(),
                          const Icon(Icons.visibility_outlined, size: 13, color: AppColors.grey500),
                          const SizedBox(width: 3),
                          Text('$views', style: AppTextStyles.caption),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => ctrl.toggleLike(update.id),
                            child: Row(
                              children: [
                                Icon(
                                  liked ? Icons.favorite : Icons.favorite_outline,
                                  size: 13,
                                  color: liked ? AppColors.statusRejected : AppColors.grey500,
                                ),
                                const SizedBox(width: 3),
                                Text('$likes', style: AppTextStyles.caption),
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
      ),
    );
  }
}
