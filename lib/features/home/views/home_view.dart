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
import '../../../routes/app_routes.dart';
import '../../shell/controllers/shell_controller.dart';
import '../../auth/controllers/auth_controller.dart';
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
              _buildHallOfExcellence(),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
              _buildGrievanceCard(),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
              _buildCommunityImpact(),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        ),
      ),
    );
  }

  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      floating: true,
      backgroundColor: AppColors.surface,
      elevation: 0,
      scrolledUnderElevation: 1,
      title: Obx(() {
        final constituencyName = Get.find<AuthController>().user.value?.constituencyName;
        final hasConstituency = constituencyName != null && constituencyName.isNotEmpty;
        final title = hasConstituency ? constituencyName : AppStrings.appName;
        return Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.rocket_launch_rounded, color: Colors.white, size: 16),
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
                  if (hasConstituency)
                    Text(
                      AppStrings.appName,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textTertiary,
                      ),
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
        if (mla == null) {
          return const SizedBox(height: 130, child: Center(child: CircularProgressIndicator()));
        }
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
        onTap: () => Get.toNamed(Routes.reportFlow),
      ),
      ActionCard(
        icon: FeatureType.idea.icon,
        title: FeatureType.idea.label,
        subtitle: FeatureType.idea.subtitle,
        accentColor: FeatureType.idea.color,
        onTap: () => Get.toNamed(Routes.ideasFlow),
      ),
      ActionCard(
        icon: FeatureType.improve.icon,
        title: FeatureType.improve.label,
        subtitle: FeatureType.improve.subtitle,
        accentColor: FeatureType.improve.color,
        onTap: () => Get.toNamed(Routes.improvementsFlow),
      ),
      ActionCard(
        icon: FeatureType.appreciate.icon,
        title: FeatureType.appreciate.label,
        subtitle: FeatureType.appreciate.subtitle,
        accentColor: FeatureType.appreciate.color,
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
        child: Column(
          children: [
            row(tiles[0], tiles[1]),
            const SizedBox(height: 12),
            row(tiles[2], tiles[3]),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildUpdatesHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SectionHeader(
          title: AppStrings.updates,
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
          final tileWidth = ((constraints.maxWidth - 32) / 2.5).clamp(132.0, 220.0);
          return SizedBox(
            height: 200,
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
                    child: _activityCard(item.title, item.imageUrl, item.timeAgo, tileWidth),
                  );
                },
              );
            }),
          );
        },
      ),
    );
  }

  SliverToBoxAdapter _buildHallOfExcellence() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: GestureDetector(
          onTap: () => Get.toNamed(Routes.achievementsListing),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2D1B69), Color(0xFF5B2EE2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.emoji_events_rounded, color: Color(0xFFFFD700), size: 20),
                    const SizedBox(width: 8),
                    Text(
                      AppStrings.hallOfExcellence,
                      style: AppTextStyles.titleSmall.copyWith(color: Colors.white, letterSpacing: 1.2),
                    ),
                    const Spacer(),
                    const Icon(Icons.chevron_right_rounded, color: Colors.white54, size: 20),
                  ],
                ),
                const SizedBox(height: 4),
                Text('SSLC Full A+ Achievers 2024', style: AppTextStyles.caption.copyWith(color: Colors.white70)),
                const SizedBox(height: 12),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.hallOfExcellence.length,
                    itemBuilder: (_, i) {
                      final s = controller.hallOfExcellence[i];
                      return Container(
                        width: 120,
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.white24,
                              child: Text(
                                s['grade']!,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 10),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              s['name']!,
                              style: AppTextStyles.caption.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              s['school']!,
                              style: const TextStyle(fontSize: 9, color: Colors.white54),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildGrievanceCard() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Material(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: () => Get.toNamed(Routes.eventsList),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.grey200),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(color: AppColors.ideaPurpleLight, borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.campaign_rounded, color: AppColors.primary, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(controller.grievanceEvent['title']!, style: AppTextStyles.titleSmall),
                        Text(controller.grievanceEvent['date']!, style: AppTextStyles.caption),
                        Text(controller.grievanceEvent['venue']!, style: AppTextStyles.caption),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => Get.toNamed(Routes.eventsList),
                    child: Text(AppStrings.viewDetails, style: AppTextStyles.labelSmall.copyWith(color: AppColors.primary)),
                  ),
                ],
              ),
            ),
          ),
        ),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.insights_rounded, color: AppColors.primary, size: 20),
                  const SizedBox(width: 8),
                  Text(AppStrings.communityImpactTitle, style: AppTextStyles.titleSmall),
                ],
              ),
              const SizedBox(height: 4),
              Text(AppStrings.communityImpactSubtitle,
                  style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary)),
              const SizedBox(height: 14),
              Obx(() {
                final reports = controller.impactReports.value;
                final ideas = controller.impactIdeas.value;
                final appreciations = controller.impactAppreciations.value;
                return Row(
                  children: [
                    _impactStat(Icons.report_problem_rounded, AppColors.reportOrange, '$reports', AppStrings.communityImpactReports),
                    _impactStat(Icons.lightbulb_outline_rounded, AppColors.primary, '$ideas', AppStrings.communityImpactIdeas),
                    _impactStat(Icons.favorite_rounded, Colors.pink, '$appreciations', AppStrings.communityImpactThanks),
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
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 6),
          Text(value, style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w700)),
          Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary)),
        ],
      ),
    );
  }

  Widget _activityCard(String title, String? imageUrl, String time, double width) {
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
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            child: imageUrl != null
                ? CachedNetworkImage(
                    imageUrl: imageUrl,
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => Container(height: 100, color: AppColors.grey200),
                  )
                : Container(
                    height: 100,
                    color: AppColors.grey200,
                    child: const Icon(Icons.image_outlined, color: AppColors.grey400),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600, fontSize: 12),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(time, style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

