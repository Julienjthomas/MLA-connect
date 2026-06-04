import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_enums.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/shimmer_loader.dart';
import '../../../core/widgets/status_chip.dart';
import '../../../routes/app_routes.dart';
import '../../../data/models/event_model.dart';
import '../../../data/models/public_board_item.dart';
import '../../../data/models/update_model.dart';
import '../controllers/updates_controller.dart';

class UpdatesView extends GetView<UpdatesController> {
  const UpdatesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
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
        bottom: TabBar(
          controller: controller.tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          indicatorSize: TabBarIndicatorSize.tab,
          labelStyle: AppTextStyles.labelSmall.copyWith(fontWeight: FontWeight.w600),
          unselectedLabelStyle: AppTextStyles.labelSmall,
          tabs: const [
            Tab(text: 'MLA Feeds'),
            Tab(text: 'Public Board'),
            Tab(text: 'Events'),
          ],
        ),
      ),
      body: TabBarView(
        controller: controller.tabController,
        children: const [
          _TabContent(tab: UpdatesTab.feeds),
          _TabContent(tab: UpdatesTab.publicBoards),
          _TabContent(tab: UpdatesTab.events),
        ],
      ),
    );
  }
}

class _TabContent extends GetView<UpdatesController> {
  final UpdatesTab tab;
  const _TabContent({required this.tab});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.loading.value) {
        return ListView.builder(
          padding: EdgeInsets.all(16.r),
          itemCount: 4,
          itemBuilder: (_, __) => const ShimmerCard(),
        );
      }
      if (controller.error.isNotEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.all(32.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  controller.error.value,
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),
                TextButton(onPressed: controller.loadUpdates, child: const Text('Retry')),
              ],
            ),
          ),
        );
      }

      if (tab == UpdatesTab.publicBoards) {
        final boardItems = controller.publicBoardItems;
        return RefreshIndicator(
          onRefresh: controller.loadUpdates,
          child: boardItems.isEmpty
              ? CustomScrollView(slivers: [SliverFillRemaining(child: _UpdatesEmptyState(tab: tab))])
              : ListView.builder(
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
                  itemCount: boardItems.length,
                  itemBuilder: (_, i) => _PublicBoardCard(item: boardItems[i]),
                ),
        );
      }

      if (tab == UpdatesTab.events) {
        final eventItems = controller.events;
        return RefreshIndicator(
          onRefresh: controller.loadUpdates,
          child: eventItems.isEmpty
              ? CustomScrollView(slivers: [SliverFillRemaining(child: _UpdatesEmptyState(tab: tab))])
              : ListView.builder(
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
                  itemCount: eventItems.length,
                  itemBuilder: (_, i) => _EventCard(event: eventItems[i]),
                ),
        );
      }

      final featured = tab == UpdatesTab.feeds ? controller.featuredUpdates : <UpdateModel>[];
      final items = controller.filteredUpdates;

      return RefreshIndicator(
        onRefresh: controller.loadUpdates,
        child: CustomScrollView(
          slivers: [
            if (featured.isNotEmpty) SliverToBoxAdapter(child: _FeaturedCarousel(items: featured)),
            if (items.isEmpty)
              SliverFillRemaining(
                child: _UpdatesEmptyState(tab: tab),
              )
            else
              SliverPadding(
                padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
                sliver: SliverList.builder(
                  itemCount: items.length,
                  itemBuilder: (_, i) => _UpdateCard(update: items[i]),
                ),
              ),
          ],
        ),
      );
    });
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
          height: 220.h,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.items.length,
            onPageChanged: (i) => setState(() => _current = i),
            itemBuilder: (_, i) => _FeaturedCard(update: widget.items[i]),
          ),
        ),
        if (widget.items.length > 1) ...[
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.items.length, (i) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: EdgeInsets.symmetric(horizontal: 3.w),
                width: _current == i ? 20.w : 6.w,
                height: 6.h,
                decoration: BoxDecoration(
                  color: _current == i ? AppColors.primary : AppColors.grey300,
                  borderRadius: BorderRadius.circular(3.r),
                ),
              );
            }),
          ),
          SizedBox(height: 4.h),
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
        margin: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
        decoration: BoxDecoration(color: AppColors.textPrimary, borderRadius: BorderRadius.circular(20.r)),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (update.imageUrl != null)
              CachedNetworkImage(
                imageUrl: update.imageUrl!,
                cacheKey: update.imageCacheKey,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => Container(color: AppColors.primaryDark),
              ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withValues(alpha: 0.3), Colors.black.withValues(alpha: 0.75)],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(20.r)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star_rounded, size: 12.r, color: Colors.white),
                        SizedBox(width: 4.w),
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
                    style: AppTextStyles.titleLarge.copyWith(color: Colors.white, fontSize: 18.sp),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined, size: 12.r, color: Colors.white70),
                      SizedBox(width: 4.w),
                      Text(update.timeAgo, style: AppTextStyles.caption.copyWith(color: Colors.white70)),
                      const Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                        decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(20.r)),
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
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.horizontal(left: Radius.circular(16.r)),
              child: update.imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: update.imageUrl!,
                      cacheKey: update.imageCacheKey,
                      width: 110.w,
                      height: 120.h,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => _UpdateCardPlaceholder(category: update.category),
                    )
                  : _UpdateCardPlaceholder(category: update.category),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CategoryChip(label: update.category.label, color: update.category.color),
                    SizedBox(height: 6.h),
                    Text(
                      update.localTitle,
                      style: AppTextStyles.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8.h),
                    Obx(() {
                      final liked = ctrl.likedIds.contains(update.id);
                      final current = ctrl.updates.firstWhereOrNull((u) => u.id == update.id);
                      final likes = current?.likes ?? update.likes;
                      return Row(
                        children: [
                          Text(update.timeAgo, style: AppTextStyles.caption),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => ctrl.toggleLike(update.id),
                            child: Row(
                              children: [
                                Icon(
                                  liked ? Icons.favorite : Icons.favorite_outline,
                                  size: 13.r,
                                  color: liked ? AppColors.statusRejected : AppColors.grey500,
                                ),
                                SizedBox(width: 3.w),
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

// ── Updates Empty State ──────────────────────────────────────────────────────

class _UpdatesEmptyState extends StatelessWidget {
  final UpdatesTab tab;
  const _UpdatesEmptyState({required this.tab});

  (IconData, Color, String, String) get _config => switch (tab) {
        UpdatesTab.feeds => (
            Icons.newspaper_rounded,
            AppColors.primary,
            'No MLA updates yet',
            'MLA posts and announcements will appear here.',
          ),
        UpdatesTab.publicBoards => (
            Icons.campaign_rounded,
            AppColors.reportOrange,
            'No public board posts',
            'Public notices and board updates will appear here.',
          ),
        UpdatesTab.events => (
            Icons.event_rounded,
            AppColors.ideaPurple,
            'No events yet',
            'Upcoming events will show up here.',
          ),
      };

  @override
  Widget build(BuildContext context) {
    final (icon, color, title, message) = _config;
    final lightColor = color.withValues(alpha: 0.12);

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80.r,
              height: 80.r,
              decoration: BoxDecoration(color: lightColor, shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 36.r),
            ),
            SizedBox(height: 20.h),
            Text(title, style: AppTextStyles.headlineSmall, textAlign: TextAlign.center),
            SizedBox(height: 8.h),
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textTertiary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _PublicBoardCard extends StatelessWidget {
  const _PublicBoardCard({required this.item});
  final PublicBoardItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48.r,
            height: 48.r,
            decoration: BoxDecoration(color: item.kindColorLight, borderRadius: BorderRadius.circular(12.r)),
            child: Icon(item.kindIcon, color: item.kindColor, size: 22.r),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: item.kindColorLight,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        item.kindLabel,
                        style: AppTextStyles.caption.copyWith(
                          color: item.kindColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 11.sp,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(item.timeAgo, style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary)),
                  ],
                ),
                SizedBox(height: 6.h),
                Text(
                  item.title,
                  style: AppTextStyles.titleMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (item.wardName != null) ...[
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: 12.r, color: AppColors.textTertiary),
                      SizedBox(width: 3.w),
                      Text(item.wardName!, style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary)),
                    ],
                  ),
                ],
                SizedBox(height: 6.h),
                StatusChip(status: item.status),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Update card placeholder ──────────────────────────────────────────────────

class _UpdateCardPlaceholder extends StatelessWidget {
  const _UpdateCardPlaceholder({required this.category});
  final UpdateCategory category;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110.w,
      height: 120.h,
      color: category.color.withValues(alpha: 0.12),
      child: Icon(Icons.article_rounded, color: category.color.withValues(alpha: 0.5), size: 36.r),
    );
  }
}

// ── Event card ───────────────────────────────────────────────────────────────

class _EventCard extends StatelessWidget {
  const _EventCard({required this.event});
  final EventModel event;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.eventDetail, arguments: event.id),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 72.w,
                decoration: BoxDecoration(
                  color: AppColors.ideaPurpleLight,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(16.r), bottomLeft: Radius.circular(16.r)),
                ),
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(event.shortMonth, style: TextStyle(fontFamily: 'Poppins', fontSize: 11.sp, fontWeight: FontWeight.w700, color: AppColors.primary, letterSpacing: 0.5)),
                    SizedBox(height: 2.h),
                    Text('${event.startsAt.day}', style: TextStyle(fontFamily: 'Poppins', fontSize: 28.sp, fontWeight: FontWeight.w800, color: AppColors.primary, height: 1)),
                    SizedBox(height: 4.h),
                    Text(event.shortWeekday, style: TextStyle(fontFamily: 'Poppins', fontSize: 10.sp, fontWeight: FontWeight.w600, color: AppColors.primary)),
                  ],
                ),
              ),
              Container(width: 1, color: AppColors.grey200),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 14.h, 14.w, 14.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(event.title, style: TextStyle(fontFamily: 'Poppins', fontSize: 15.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary, height: 1.3), maxLines: 2, overflow: TextOverflow.ellipsis),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          Icon(Icons.access_time_rounded, size: 14.r, color: AppColors.primary.withValues(alpha: 0.7)),
                          SizedBox(width: 5.w),
                          Text(event.formattedTime, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontSize: 12.sp)),
                          if (event.venue.isNotEmpty) ...[
                            Container(margin: EdgeInsets.symmetric(horizontal: 10.w), width: 1, height: 12.h, color: AppColors.grey200),
                            Icon(Icons.location_on_outlined, size: 14.r, color: AppColors.primary.withValues(alpha: 0.7)),
                            SizedBox(width: 5.w),
                            Expanded(child: Text(event.venue, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontSize: 12.sp), maxLines: 1, overflow: TextOverflow.ellipsis)),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
