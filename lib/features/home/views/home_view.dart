import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_enums.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/action_card.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/shimmer_loader.dart';
import '../../../core/utils/date_formatter.dart';
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
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
              _buildHeroBanner(),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
              _buildWhatWouldYouLike(),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
              _buildActionGrid(context),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
              _buildUpdatesHeader(),
              const SliverToBoxAdapter(child: SizedBox(height: 12)),
              _buildUpdatesFeed(),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
              _buildCommunityImpact(),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
              _buildStayConnected(),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
              _buildAnnouncementsHeader(),
              const SliverToBoxAdapter(child: SizedBox(height: 12)),
              _buildGrievanceBanner(),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
              _buildUpcomingEventsSection(),
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
              borderRadius: BorderRadius.circular(8),
              child: Image.asset('assets/images/nameless_logo.png', width: 49, height: 49, fit: BoxFit.cover),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
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
            IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {}),
            Positioned(
              right: 10,
              top: 10,
              child: Container(
                width: 8,
                height: 8,
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
          return const SizedBox(height: 130, child: Center(child: CircularProgressIndicator()));
        }
        if (mla == null) return const SizedBox.shrink();
        return MlaHeroBanner(mla: mla);
      }),
    );
  }

  SliverToBoxAdapter _buildWhatWouldYouLike() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.whatWouldYouLike,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
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

  // Tiles order: Report, Idea, Improve, Appreciate.
  // IntrinsicHeight makes both tiles in a row match the tallest's natural height.
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
          const SizedBox(width: 12),
          Expanded(child: b),
        ],
      ),
    );

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(children: [row(tiles[0], tiles[1]), const SizedBox(height: 12), row(tiles[2], tiles[3])]),
      ),
    );
  }

  SliverToBoxAdapter _buildUpdatesHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SectionHeader(
          title: AppStrings.recentUpdates,
          actionLabel: AppStrings.viewAll,
          onAction: () {
            // Switch to Updates tab (index 2)
            try {
              Get.find<ShellController>().goTo(2);
            } catch (_) {
              Get.toNamed(Routes.updateDetail);
            }
          },
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildUpdatesFeed() {
    return SliverToBoxAdapter(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tileWidth = ((constraints.maxWidth - 32) / 2.2).clamp(150.0, 220.0);
          return SizedBox(
            height: 190,
            child: Obx(() {
              if (controller.loading.value) {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: 3,
                  itemBuilder: (_, __) =>
                      Container(width: tileWidth, margin: const EdgeInsets.only(right: 12), child: const ShimmerCard()),
                );
              }
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: controller.recentActivity.length,
                itemBuilder: (_, i) {
                  final item = controller.recentActivity[i];
                  return GestureDetector(
                    onTap: () => Get.toNamed(Routes.updateDetail, arguments: item.id),
                    child: _activityCard(item, tileWidth),
                  );
                },
              );
            }),
          );
        },
      ),
    );
  }

  SliverToBoxAdapter _buildCommunityImpact() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.grey200),
          ),
          child: Row(
            children: [
              // Left — icon + title/subtitle
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(color: AppColors.ideaPurpleLight, borderRadius: BorderRadius.circular(14)),
                child: const Icon(Icons.bar_chart_rounded, color: AppColors.primary, size: 26),
              ),
              const SizedBox(width: 12),
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
              const SizedBox(width: 12),
              // Right — 3 stats
              Obx(() {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _impactStat(
                      Icons.list_alt_rounded,
                      AppColors.primary,
                      '${controller.impactReports.value}',
                      'Issues\nRaised',
                    ),
                    const SizedBox(width: 16),
                    _impactStat(
                      Icons.folder_open_rounded,
                      AppColors.appreciateGreen,
                      '${controller.impactIdeas.value}',
                      'Active\nProjects',
                    ),
                    const SizedBox(width: 16),
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
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(color: color.withValues(alpha: 0.12), shape: BoxShape.circle),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w700, color: color),
        ),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary, fontSize: 9, height: 1.2),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  SliverToBoxAdapter _buildStayConnected() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF5B2EE2), Color(0xFF7B52F0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), shape: BoxShape.circle),
                child: const Icon(Icons.campaign_rounded, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Stay informed, stay connected!',
                      style: AppTextStyles.titleSmall.copyWith(color: Colors.white, fontSize: 13),
                    ),
                    const SizedBox(height: 2),
                    Text('Get the latest announcements.', style: AppTextStyles.caption.copyWith(color: Colors.white70)),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () {
                  try {
                    Get.find<ShellController>().goTo(2);
                    Get.find<UpdatesController>().selectCategory(UpdateCategory.announcements);
                  } catch (_) {}
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: const Icon(Icons.arrow_forward_rounded, color: AppColors.primary, size: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildAnnouncementsHeader() {
    return SliverToBoxAdapter(
      child: Obx(() {
        if (controller.announcements.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SectionHeader(
            title: 'Announcements',
            actionLabel: AppStrings.viewAll,
            onAction: () {
              try {
                Get.find<ShellController>().goTo(2);
                Get.find<UpdatesController>().tabController.animateTo(1);
              } catch (_) {}
            },
          ),
        );
      }),
    );
  }

  SliverToBoxAdapter _buildGrievanceBanner() {
    final pageIndex = ValueNotifier<int>(0);
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Obx(() {
          final items = controller.announcements;
          if (items.isEmpty) return const SizedBox.shrink();
          return ValueListenableBuilder<int>(
            valueListenable: pageIndex,
            builder: (context, current, _) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 90,
                    child: PageView.builder(
                      itemCount: items.length,
                      onPageChanged: (i) => pageIndex.value = i,
                      itemBuilder: (_, i) {
                        final item = items[i];
                        return GestureDetector(
                          onTap: () => Get.toNamed(Routes.updateDetail, arguments: item.id),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 1),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.grey200),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: const BoxDecoration(
                                    color: AppColors.ideaPurpleLight,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.campaign_rounded, color: AppColors.primary, size: 22),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        item.localTitle,
                                        style: AppTextStyles.titleSmall,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        item.timeAgo,
                                        style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  AppStrings.viewDetails,
                                  style: AppTextStyles.labelSmall.copyWith(color: AppColors.primary),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(items.length, (i) {
                      final active = i == current;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: active ? 16 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: active ? AppColors.primary : AppColors.grey200,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      );
                    }),
                  ),
                ],
              );
            },
          );
        }),
      ),
    );
  }

  SliverToBoxAdapter _buildUpcomingEventsSection() {
    return SliverToBoxAdapter(
      child: Obx(() {
        final events = controller.upcomingEvents.take(5).toList();
        if (events.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SectionHeader(
                title: 'Upcoming Events',
                actionLabel: AppStrings.viewAll,
                onAction: () {
                  try {
                    Get.find<ShellController>().goTo(2);
                    Get.find<UpdatesController>().tabController.animateTo(1);
                  } catch (_) {}
                },
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 190,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: events.length,
                itemBuilder: (_, i) => _eventCard(events[i]),
              ),
            ),
            const SizedBox(height: 24),
          ],
        );
      }),
    );
  }

  Widget _eventCard(UpdateModel item) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.updateDetail, arguments: item.id),
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6, offset: const Offset(0, 2)),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            item.imageUrl != null
                ? CachedNetworkImage(
                    imageUrl: item.imageUrl!,
                    cacheKey: item.imageCacheKey,
                    height: 110,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => _eventCardPlaceholder(),
                  )
                : _eventCardPlaceholder(),
            // Text
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.localTitle,
                    style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600, fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, size: 10, color: AppColors.textTertiary),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          item.timeAgo,
                          style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary, fontSize: 10),
                          overflow: TextOverflow.ellipsis,
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

  Widget _eventCardPlaceholder() {
    return Container(
      height: 110,
      color: AppColors.ideaPurpleLight,
      child: const Center(child: Icon(Icons.event_rounded, color: AppColors.primary, size: 32)),
    );
  }

  Widget _activityCardPlaceholder(UpdateModel item) {
    final color = item.category.color;
    return Container(
      height: 110,
      width: double.infinity,
      color: color.withValues(alpha: 0.12),
      child: Icon(Icons.campaign_rounded, color: color, size: 36),
    );
  }

  Widget _activityCard(UpdateModel item, double width) {
    return Container(
      width: width,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            child: item.imageUrl != null
                ? CachedNetworkImage(
                    imageUrl: item.imageUrl!,
                    cacheKey: item.imageCacheKey,
                    height: 110,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => _activityCardPlaceholder(item),
                  )
                : _activityCardPlaceholder(item),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.localTitle,
                  style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600, fontSize: 12),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.favorite_outline, size: 10, color: AppColors.textTertiary),
                    const SizedBox(width: 3),
                    Text(
                      '${item.likes}',
                      style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary, fontSize: 10),
                    ),
                    const Spacer(),
                    Text(
                      DateFormatter.timeAgo(item.createdAt),
                      style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary, fontSize: 10),
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
