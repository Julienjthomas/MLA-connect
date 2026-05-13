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
        return Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.rocket_launch_rounded, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppStrings.appName,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                if (constituencyName != null && constituencyName.isNotEmpty)
                  Text(
                    constituencyName,
                    style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                  ),
              ],
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
        const SizedBox(width: 8),
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
    return const SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'What would you like to\nshare today?',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                height: 1.3,
              ),
            ),
            SizedBox(height: 2),
            Text(
              AppStrings.tagline,
              style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: AppColors.textTertiary),
            ),
          ],
        ),
      ),
    );
  }

  // Tiles order: Report, Idea, Improve, Appreciate
  SliverPadding _buildActionGrid(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    // Reserve space for: SafeArea (~44), AppBar (~56), hero (~130+16), section title (~60), bottom nav (~60), paddings
    // Give action grid ~30% of screen height so all 4 tiles are visible
    final gridHeight = (screenHeight * 0.30).clamp(200.0, 280.0);
    final tileSize = (gridHeight - 12) / 2; // 2 rows, 12 spacing
    final aspectRatio = ((MediaQuery.of(context).size.width - 44) / 2.8) / tileSize;

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        delegate: SliverChildListDelegate([
          ActionCard(
            icon: FeatureType.report.icon,
            title: 'Report Problem',
            subtitle: FeatureType.report.subtitle,
            accentColor: FeatureType.report.color,
            onTap: () => Get.toNamed(Routes.reportFlow),
          ),
          ActionCard(
            icon: FeatureType.idea.icon,
            title: 'Share Idea',
            subtitle: FeatureType.idea.subtitle,
            accentColor: FeatureType.idea.color,
            onTap: () => Get.toNamed(Routes.ideasFlow),
          ),
          ActionCard(
            icon: FeatureType.improve.icon,
            title: 'Suggest Improvement',
            subtitle: FeatureType.improve.subtitle,
            accentColor: FeatureType.improve.color,
            onTap: () => Get.toNamed(Routes.improvementsFlow),
          ),
          ActionCard(
            icon: FeatureType.appreciate.icon,
            title: 'Appreciate',
            subtitle: FeatureType.appreciate.subtitle,
            accentColor: FeatureType.appreciate.color,
            onTap: () => Get.toNamed(Routes.appreciationFlow),
          ),
        ]),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: aspectRatio,
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildUpdatesHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SectionHeader(
          title: AppStrings.mlaActivity,
          actionLabel: AppStrings.viewAll,
          onAction: () {
            // Switch to Updates tab (index 2)
            try {
              Get.find<ShellController>().goTo(3);
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
      child: SizedBox(
        height: 200,
        child: Obx(() {
          if (controller.loading.value) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 3,
              itemBuilder: (_, __) =>
                  Container(width: 200, margin: const EdgeInsets.only(right: 12), child: const ShimmerCard()),
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
                child: _activityCard(item.title, item.imageUrl, item.timeAgo, item.id),
              );
            },
          );
        }),
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
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
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
                onPressed: () {},
                child: Text(AppStrings.viewDetails, style: AppTextStyles.labelSmall.copyWith(color: AppColors.primary)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _activityCard(String title, String? imageUrl, String time, String id) {
    return Container(
      width: 150,
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
