import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_enums.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/action_card.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/event_model.dart';
import '../../../data/models/post/post_response.dart';
import '../../../data/models/update_model.dart';
import '../../../routes/app_routes.dart';
import '../../shell/controllers/shell_controller.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../updates/controllers/updates_controller.dart';
import '../controllers/home_controller.dart';
import '../widgets/mla_hero_banner.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.loadData,
          child: CustomScrollView(
            slivers: [
              _buildAppBar(),
              SliverToBoxAdapter(child: SizedBox(height: 16.h)),
              _buildHeroBanner(),
              SliverToBoxAdapter(child: SizedBox(height: 20.h)),
              _buildWhatWouldYouLike(),
              SliverToBoxAdapter(child: SizedBox(height: 16.h)),
              _buildActionGrid(context),
              _buildRecentUpdatesSection(),
              _buildCommunityImpact(),
              _buildBottomSections(),
              SliverToBoxAdapter(child: SizedBox(height: 16.h)),
            ],
          ),
        ),
      ),
    );
  }

  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      floating: true,
      backgroundColor: AppColors.background,
      elevation: 0,
      scrolledUnderElevation: 1,
      title: Obx(() {
        final constituencyName = Get.find<AuthController>().user.value?.constituencyName;
        final hasConstituency = constituencyName != null && constituencyName.isNotEmpty;
        final title = hasConstituency ? constituencyName : AppStrings.appName;
        return Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.asset('assets/images/nameless_logo.png', width: 49.r, height: 49.r, fit: BoxFit.cover),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        );
      }),
      actions: [
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () => Get.toNamed(Routes.notifications),
            ),
            Positioned(
              right: 10,
              top: 10,
              child: Container(
                width: 8.r,
                height: 8.r,
                decoration: const BoxDecoration(color: AppColors.reportOrange, shape: BoxShape.circle),
              ),
            ),
          ],
        ),
      ],
    );
  }

  SliverToBoxAdapter _buildHeroBanner() {
    return SliverToBoxAdapter(
      child: Obx(() {
        final mla = controller.mla.value;
        if (mla == null && controller.mlaLoading.value) {
          return SizedBox(height: 130.h, child: const Center(child: CircularProgressIndicator()));
        }
        if (mla == null) return const SizedBox.shrink();
        return MlaHeroBanner(mla: mla);
      }),
    );
  }

  SliverToBoxAdapter _buildWhatWouldYouLike() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.whatWouldYouLike,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildActionGrid(BuildContext context) {
    final tiles = [
      ActionCard(
        icon: FeatureType.report.icon,
        title: FeatureType.report.label,
        subtitle: FeatureType.report.subtitle,
        accentColor: FeatureType.report.color,
        backgroundImage: FeatureType.report.backgroundImage,
        onTap: () => Get.toNamed(Routes.reportFlow),
      ),
      ActionCard(
        icon: FeatureType.idea.icon,
        title: FeatureType.idea.label,
        subtitle: FeatureType.idea.subtitle,
        accentColor: FeatureType.idea.color,
        backgroundImage: FeatureType.idea.backgroundImage,
        onTap: () => Get.toNamed(Routes.ideasFlow),
      ),
      ActionCard(
        icon: FeatureType.improve.icon,
        title: FeatureType.improve.label,
        subtitle: FeatureType.improve.subtitle,
        accentColor: FeatureType.improve.color,
        backgroundImage: FeatureType.improve.backgroundImage,
        onTap: () => Get.toNamed(Routes.improvementsFlow),
      ),
      ActionCard(
        icon: FeatureType.appreciate.icon,
        title: FeatureType.appreciate.label,
        subtitle: FeatureType.appreciate.subtitle,
        accentColor: FeatureType.appreciate.color,
        backgroundImage: FeatureType.appreciate.backgroundImage,
        onTap: () => Get.toNamed(Routes.appreciationFlow),
      ),
    ];

    Widget row(Widget a, Widget b) => IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: a),
          SizedBox(width: 12.w),
          Expanded(child: b),
        ],
      ),
    );

    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(children: [row(tiles[0], tiles[1]), SizedBox(height: 12.h), row(tiles[2], tiles[3])]),
      ),
    );
  }

  SliverToBoxAdapter _buildRecentUpdatesSection() {
    return SliverToBoxAdapter(
      child: Obx(() {
        final items = controller.recentActivity;
        if (items.isEmpty) return const SizedBox.shrink();

        return LayoutBuilder(
          builder: (context, constraints) {
            final tileWidth = ((constraints.maxWidth - 32) / 2.2).clamp(150.0, 220.0);
            final cardHeight = (190 * MediaQuery.textScalerOf(context).scale(1.0)).clamp(190.0, 260.0);
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 24.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: SectionHeader(
                    title: AppStrings.recentUpdates,
                    actionLabel: AppStrings.viewAll,
                    onAction: () {
                      try {
                        Get.find<ShellController>().goTo(2);
                      } catch (_) {
                        Get.toNamed(Routes.updateDetail);
                      }
                    },
                  ),
                ),
                SizedBox(height: 12.h),
                SizedBox(
                  height: cardHeight,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: items.length,
                    itemBuilder: (_, i) {
                      final item = items[i];
                      return GestureDetector(
                        onTap: () => Get.toNamed(Routes.updateDetail, arguments: item.id),
                        child: _activityCard(item, tileWidth),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      }),
    );
  }

  SliverToBoxAdapter _buildCommunityImpact() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 0),
        child: Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.grey200),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 48.r,
                height: 48.r,
                decoration: BoxDecoration(color: AppColors.ideaPurpleLight, borderRadius: BorderRadius.circular(14.r)),
                child: Icon(Icons.bar_chart_rounded, color: AppColors.primary, size: 26.r),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppStrings.communityImpactTitle, style: AppTextStyles.titleSmall),
                    Text(
                      AppStrings.communityImpactSubtitle,
                      style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Obx(() {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _impactStat(
                      Icons.list_alt_rounded,
                      AppColors.primary,
                      '${controller.impactReports.value}',
                      'Issues\nRaised',
                    ),
                    SizedBox(width: 16.w),
                    _impactStat(
                      Icons.folder_open_rounded,
                      AppColors.appreciateGreen,
                      '${controller.impactIdeas.value}',
                      'Active\nProjects',
                    ),
                    SizedBox(width: 16.w),
                    _impactStat(
                      Icons.people_alt_rounded,
                      AppColors.reportOrange,
                      '${controller.impactAppreciations.value}',
                      'Citizens',
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _impactStat(IconData icon, Color color, String value, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 40.r,
          height: 40.r,
          decoration: BoxDecoration(color: color.withValues(alpha: 0.12), shape: BoxShape.circle),
          child: Icon(icon, color: color, size: 20.r),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w700, color: color),
        ),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary, fontSize: 9.sp, height: 1.2),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  SliverToBoxAdapter _buildBottomSections() {
    return SliverToBoxAdapter(
      child: Obx(() {
        final events = controller.upcomingEvents.toList();
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF5B2EE2), Color(0xFF7B52F0)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 52.r,
                      height: 52.r,
                      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), shape: BoxShape.circle),
                      child: Icon(Icons.campaign_rounded, color: Colors.white, size: 28.r),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Stay informed, stay connected!',
                            style: AppTextStyles.titleSmall.copyWith(color: Colors.white, fontSize: 13.sp),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Get the latest announcements.',
                            style: AppTextStyles.caption.copyWith(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12.w),
                    GestureDetector(
                      onTap: () {
                        try {
                          Get.find<ShellController>().goTo(2);
                          Get.find<UpdatesController>().selectCategory(UpdateCategory.announcements);
                        } catch (_) {}
                      },
                      child: Container(
                        width: 36.r,
                        height: 36.r,
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: Icon(Icons.arrow_forward_rounded, color: AppColors.primary, size: 18.r),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (events.isNotEmpty) ...[
              SizedBox(height: 24.h),
              _EventsCarousel(
                events: events,
                onViewAll: () {
                  try {
                    Get.find<ShellController>().goTo(2);
                    Get.find<UpdatesController>().tabController.animateTo(2);
                  } catch (_) {}
                },
              ),
            ],
            Obx(() {
              final posts = controller.recentPosts.toList();
              if (posts.isEmpty) return const SizedBox.shrink();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: SectionHeader(
                      title: 'MLA Posts',
                      actionLabel: AppStrings.viewAll,
                      onAction: () => Get.toNamed(Routes.postsList),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  SizedBox(
                    height: 130.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      itemCount: posts.take(5).length,
                      itemBuilder: (_, i) => _PostMiniCard(post: posts[i]),
                    ),
                  ),
                ],
              );
            }),
          ],
        );
      }),
    );
  }

  Widget _activityCardPlaceholder(UpdateModel item) {
    final color = item.category.color;
    return Container(
      height: 110.h,
      width: double.infinity,
      color: color.withValues(alpha: 0.12),
      child: Icon(Icons.campaign_rounded, color: color, size: 36.r),
    );
  }

  Widget _activityCard(UpdateModel item, double width) {
    return Container(
      width: width,
      margin: EdgeInsets.only(right: 12.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(14.r)),
            child: item.imageUrl != null
                ? CachedNetworkImage(
                    imageUrl: item.imageUrl!,
                    cacheKey: item.imageCacheKey,
                    height: 110.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => _activityCardPlaceholder(item),
                  )
                : _activityCardPlaceholder(item),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(8.w, 6.h, 8.w, 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.localTitle,
                  style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600, fontSize: 12.sp),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(Icons.favorite_outline, size: 10.r, color: AppColors.textTertiary),
                    SizedBox(width: 3.w),
                    Text(
                      '${item.likes}',
                      style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary, fontSize: 10.sp),
                    ),
                    const Spacer(),
                    Text(
                      DateFormatter.timeAgo(item.createdAt),
                      style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary, fontSize: 10.sp),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Post mini card ───────────────────────────────────────────────────────────

class _PostMiniCard extends StatelessWidget {
  const _PostMiniCard({required this.post});
  final PostResponse post;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.postDetail, arguments: {'id': post.id}),
      child: Container(
        width: 160.w,
        margin: EdgeInsets.only(right: 12.w),
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6, offset: const Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 28.r, height: 28.r,
              decoration: const BoxDecoration(color: AppColors.ideaPurpleLight, shape: BoxShape.circle),
              child: Icon(Icons.article_rounded, color: AppColors.primary, size: 16.r),
            ),
            SizedBox(height: 8.h),
            Expanded(
              child: Text(post.title, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600), maxLines: 3, overflow: TextOverflow.ellipsis),
            ),
            SizedBox(height: 6.h),
            Row(
              children: [
                Icon(Icons.favorite_border_rounded, size: 12.r, color: AppColors.grey400),
                SizedBox(width: 3.w),
                Text('${post.likes}', style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary, fontSize: 10.sp)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Events carousel with page indicator ─────────────────────────────────────

class _EventsCarousel extends StatefulWidget {
  const _EventsCarousel({required this.events, required this.onViewAll});
  final List<EventModel> events;
  final VoidCallback onViewAll;

  @override
  State<_EventsCarousel> createState() => _EventsCarouselState();
}

class _EventsCarouselState extends State<_EventsCarousel> {
  final _controller = PageController(viewportFraction: 0.92);
  int _current = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: SectionHeader(title: 'Upcoming Events', actionLabel: AppStrings.viewAll, onAction: widget.onViewAll),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 110.h,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.events.length,
            onPageChanged: (i) => setState(() => _current = i),
            itemBuilder: (_, i) =>
                Padding(padding: EdgeInsets.symmetric(horizontal: 6.w), child: _eventCard(widget.events[i])),
          ),
        ),
        if (widget.events.length > 1) ...[
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.events.length, (i) {
              final active = i == _current;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: EdgeInsets.symmetric(horizontal: 3.w),
                width: active ? 16.w : 6.w,
                height: 6.h,
                decoration: BoxDecoration(
                  color: active ? AppColors.primary : AppColors.primary.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(3.r),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }

  Widget _eventCard(EventModel event) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.eventDetail, arguments: event.id),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 2))],
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
                  mainAxisSize: MainAxisSize.min,
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
                  padding: EdgeInsets.fromLTRB(16.w, 12.h, 14.w, 12.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(event.title, style: TextStyle(fontFamily: 'Poppins', fontSize: 15.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary, height: 1.3), maxLines: 2, overflow: TextOverflow.ellipsis),
                      SizedBox(height: 8.h),
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
