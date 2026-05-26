import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_enums.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/action_card.dart';
import '../../../core/widgets/section_header.dart';
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
              _buildRecentUpdatesSection(),
              _buildCommunityImpact(),
              _buildBottomSections(),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
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
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
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
                const SizedBox(height: 12),
                SizedBox(
                  height: cardHeight,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
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
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.grey200),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
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
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
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

  SliverToBoxAdapter _buildBottomSections() {
    return SliverToBoxAdapter(
      child: Obx(() {
        final events = controller.upcomingEvents.toList();
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Padding(
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
                          Text(
                            'Get the latest announcements.',
                            style: AppTextStyles.caption.copyWith(color: Colors.white70),
                          ),
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
            if (events.isNotEmpty) ...[
              const SizedBox(height: 24),
              _EventsCarousel(
                events: events,
                onViewAll: () {
                  try {
                    Get.find<ShellController>().goTo(2);
                    Get.find<UpdatesController>().tabController.animateTo(1);
                  } catch (_) {}
                },
              ),
            ],
          ],
        );
      }),
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

// ── Events carousel with page indicator ─────────────────────────────────────

class _EventsCarousel extends StatefulWidget {
  const _EventsCarousel({required this.events, required this.onViewAll});
  final List<UpdateModel> events;
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
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SectionHeader(title: 'Upcoming Events', actionLabel: AppStrings.viewAll, onAction: widget.onViewAll),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 110,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.events.length,
            onPageChanged: (i) => setState(() => _current = i),
            itemBuilder: (_, i) =>
                Padding(padding: const EdgeInsets.symmetric(horizontal: 6), child: _eventCard(widget.events[i])),
          ),
        ),
        if (widget.events.length > 1) ...[
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.events.length, (i) {
              final active = i == _current;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: active ? 16 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: active ? AppColors.primary : AppColors.primary.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }

  Widget _eventCard(UpdateModel item) {
    final date = item.createdAt;
    final months = ['JAN','FEB','MAR','APR','MAY','JUN','JUL','AUG','SEP','OCT','NOV','DEC'];
    final days = ['MON','TUE','WED','THU','FRI','SAT','SUN'];
    final month = months[(date.month - 1).clamp(0, 11)];
    final weekday = days[(date.weekday - 1).clamp(0, 6)];
    final h = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final m = date.minute.toString().padLeft(2, '0');
    final period = date.hour < 12 ? 'AM' : 'PM';
    final time = '$h:$m $period';
    final venue = item.shortBody.isNotEmpty ? item.shortBody : '';

    return GestureDetector(
      onTap: () => Get.toNamed(Routes.updateDetail, arguments: item.id),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 72,
                decoration: const BoxDecoration(
                  color: AppColors.ideaPurpleLight,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(month, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary, letterSpacing: 0.5)),
                    const SizedBox(height: 2),
                    Text('${date.day}', style: const TextStyle(fontFamily: 'Poppins', fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.primary, height: 1)),
                    const SizedBox(height: 4),
                    Text(weekday, style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.primary)),
                  ],
                ),
              ),
              Container(width: 1, color: AppColors.grey200),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(item.localTitle, style: const TextStyle(fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary, height: 1.3), maxLines: 2, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.access_time_rounded, size: 14, color: AppColors.primary.withValues(alpha: 0.7)),
                          const SizedBox(width: 5),
                          Text(time, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontSize: 12)),
                          if (venue.isNotEmpty) ...[
                            Container(margin: const EdgeInsets.symmetric(horizontal: 10), width: 1, height: 12, color: AppColors.grey200),
                            Icon(Icons.location_on_outlined, size: 14, color: AppColors.primary.withValues(alpha: 0.7)),
                            const SizedBox(width: 5),
                            Expanded(child: Text(venue, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis)),
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
