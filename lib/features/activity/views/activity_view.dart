import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_enums.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/activity_card.dart';
import '../../../core/widgets/shimmer_loader.dart';
import '../../../core/widgets/status_chip.dart';
import '../../../routes/app_routes.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/activity_controller.dart';

class ActivityView extends GetView<ActivityController> {
  const ActivityView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: _ActivityShell(controller: controller),
    );
  }
}

class _ActivityShell extends StatefulWidget {
  final ActivityController controller;

  const _ActivityShell({required this.controller});

  @override
  State<_ActivityShell> createState() => _ActivityShellState();
}

class _ActivityShellState extends State<_ActivityShell> {
  static const _listPadding = EdgeInsets.fromLTRB(16, 16, 16, 88);

  TabController? _tabController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final next = DefaultTabController.of(context);
    if (_tabController != next) {
      _tabController?.removeListener(_onTabChanged);
      _tabController = next;
      _tabController!.addListener(_onTabChanged);
    }
  }

  @override
  void dispose() {
    _tabController?.removeListener(_onTabChanged);
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController?.indexIsChanging == false) {
      setState(() {});
    }
  }

  static const _tabs = [
    ActivityTab.reports,
    ActivityTab.ideas,
    ActivityTab.improvements,
    ActivityTab.appreciations,
  ];

  void _openAddFlow(ActivityTab tab) {
    final route = switch (tab) {
      ActivityTab.reports => Routes.reportFlow,
      ActivityTab.ideas => Routes.ideasFlow,
      ActivityTab.improvements => Routes.improvementsFlow,
      ActivityTab.appreciations => Routes.appreciationFlow,
      ActivityTab.saved => null,
    };
    if (route != null) {
      Get.toNamed(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tab = _tabs[_tabController?.index ?? 0];
    final addFeature = tab.addFeature;
    final addLabel = tab.addActionLabel;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        leading: const SizedBox.shrink(),
        centerTitle: false,
        leadingWidth: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppStrings.myActivity, style: AppTextStyles.titleLarge),
            Text(AppStrings.seeYourImpact, style: AppTextStyles.caption),
          ],
        ),
        actions: const [],
      ),
      floatingActionButton: addFeature == null || addLabel == null
          ? null
          : Obx(() {
              final isEmpty = switch (tab) {
                ActivityTab.reports => widget.controller.reports.isEmpty,
                ActivityTab.ideas => widget.controller.ideas.isEmpty,
                ActivityTab.improvements => widget.controller.improvements.isEmpty,
                ActivityTab.appreciations => widget.controller.appreciations.isEmpty,
                ActivityTab.saved => true,
              };
              if (isEmpty) return const SizedBox.shrink();
              return FloatingActionButton(
                onPressed: () => _openAddFlow(tab),
                backgroundColor: addFeature.color,
                child: const Icon(Icons.add_rounded, color: Colors.white),
              );
            }),
      body: Column(
        children: [
          Obx(() {
            final auth = Get.find<AuthController>();
            final name = auth.user.value?.name ?? '';
            final firstName = name.split(' ').first;
            final total = widget.controller.totalReports +
                widget.controller.totalIdeas +
                widget.controller.totalImprovements +
                widget.controller.totalAppreciations;
            if (total == 0) return const SizedBox.shrink();
            return _ContributionBanner(firstName: firstName, total: total);
          }),
          Container(
            color: AppColors.surface,
            child: TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              indicatorColor: AppColors.primary,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.grey500,
              labelStyle: AppTextStyles.labelMedium,
              tabs: _tabs.map((t) => Tab(
                icon: t.addFeature != null ? Icon(t.addFeature!.icon, size: 16) : null,
                iconMargin: const EdgeInsets.only(bottom: 2),
                text: t.label,
              )).toList(),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (widget.controller.loading.value) {
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: 5,
                  itemBuilder: (_, __) => const ShimmerCard(),
                );
              }
              return TabBarView(
                children: [
                  _ReportsTab(controller: widget.controller, listPadding: _listPadding),
                  _IdeasTab(controller: widget.controller, listPadding: _listPadding),
                  _ImprovementsTab(controller: widget.controller, listPadding: _listPadding),
                  _AppreciationsTab(controller: widget.controller, listPadding: _listPadding),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _ContributionBanner extends StatelessWidget {
  final String firstName;
  final int total;

  const _ContributionBanner({required this.firstName, required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.fromLTRB(20, 20, 16, 20),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.waving_hand_rounded, color: AppColors.primary, size: 20),
                    const SizedBox(width: 6),
                    Text(
                      firstName.isNotEmpty
                          ? AppStrings.activityGreatGoingNamed(firstName)
                          : AppStrings.activityGreatGoing,
                      style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  AppStrings.activityContributionsSoFar(total),
                  style: AppTextStyles.headlineLarge.copyWith(color: AppColors.primary, height: 1.2),
                ),
                const SizedBox(height: 6),
                Text(
                  AppStrings.activityCommunityTagline,
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () {},
            child: Column(
              children: [
                const Icon(Icons.trending_up_rounded, color: AppColors.primary, size: 28),
                const SizedBox(height: 4),
                Text(
                  AppStrings.yourImpact,
                  style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
                ),
                Text(
                  AppStrings.keepItUp,
                  style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyActivitySection extends StatelessWidget {
  const _EmptyActivitySection();

  static const _allTabs = [
    ActivityTab.reports,
    ActivityTab.ideas,
    ActivityTab.improvements,
    ActivityTab.appreciations,
  ];

  static String _routeFor(ActivityTab t) => switch (t) {
        ActivityTab.reports => Routes.reportFlow,
        ActivityTab.ideas => Routes.ideasFlow,
        ActivityTab.improvements => Routes.improvementsFlow,
        ActivityTab.appreciations => Routes.appreciationFlow,
        ActivityTab.saved => '',
      };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.whatWouldYouLike, style: AppTextStyles.headlineSmall),
          const SizedBox(height: 4),
          Text(
            AppStrings.chooseOptionToStart,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
          ),
          const SizedBox(height: 16),
          ..._allTabs.map((tab) {
            final feature = tab.addFeature!;
            return _ActionListTile(
              icon: feature.icon,
              title: feature.label,
              subtitle: feature.subtitle,
              accentColor: feature.color,
              accentColorLight: feature.lightColor,
              onTap: () => Get.toNamed(_routeFor(tab)),
            );
          }),
        ],
      ),
    );
  }
}

class _ActionListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color accentColor;
  final Color accentColorLight;
  final VoidCallback onTap;

  const _ActionListTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.accentColorLight,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.grey200),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(color: accentColorLight, shape: BoxShape.circle),
              child: Icon(icon, color: accentColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.titleSmall),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.primary, size: 22),
          ],
        ),
      ),
    );
  }
}

class _ReportsTab extends StatelessWidget {
  final ActivityController controller;
  final EdgeInsets listPadding;
  const _ReportsTab({required this.controller, required this.listPadding});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final reports = controller.reports;
      if (reports.isEmpty) {
        return const SingleChildScrollView(child: _EmptyActivitySection());
      }
      return ListView.builder(
        padding: listPadding,
        itemCount: reports.length,
        itemBuilder: (_, i) {
          final r = reports[i];
          return ActivityCard(
            title: r.title,
            id: r.shortId,
            ward: r.wardName,
            status: r.status,
            timeAgo: r.timeAgo,
            imageUrl: r.mediaUrls.isNotEmpty ? r.mediaUrls.first : null,
            accentColor: AppColors.reportOrange,
            accentColorLight: AppColors.reportOrangeLight,
            placeholderIcon: Icons.report_rounded,
            onTap: () => Get.toNamed(Routes.reportDetail, arguments: r.id),
          );
        },
      );
    });
  }
}

class _IdeasTab extends StatelessWidget {
  final ActivityController controller;
  final EdgeInsets listPadding;
  const _IdeasTab({required this.controller, required this.listPadding});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final ideas = controller.ideas;
      if (ideas.isEmpty) {
        return const SingleChildScrollView(child: _EmptyActivitySection());
      }
      return ListView.builder(
        padding: listPadding,
        itemCount: ideas.length,
        itemBuilder: (_, i) {
          final idea = ideas[i];
          return ActivityCard(
            title: idea.title,
            id: idea.id.length > 6 ? idea.id.substring(idea.id.length - 6).toUpperCase() : idea.id.toUpperCase(),
            timeAgo: idea.timeAgo,
            imageUrl: idea.mediaUrls.isNotEmpty ? idea.mediaUrls.first : null,
            accentColor: AppColors.ideaPurple,
            accentColorLight: AppColors.ideaPurpleLight,
            placeholderIcon: Icons.lightbulb_rounded,
            statusWidget: CategoryChip(label: idea.topic, color: AppColors.ideaPurple),
            onTap: () => Get.toNamed(Routes.ideaDetail, arguments: idea),
          );
        },
      );
    });
  }
}

class _ImprovementsTab extends StatelessWidget {
  final ActivityController controller;
  final EdgeInsets listPadding;
  const _ImprovementsTab({required this.controller, required this.listPadding});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final improvements = controller.improvements;
      if (improvements.isEmpty) {
        return const SingleChildScrollView(child: _EmptyActivitySection());
      }
      return ListView.builder(
        padding: listPadding,
        itemCount: improvements.length,
        itemBuilder: (_, i) {
          final imp = improvements[i];
          final shortId = imp.id.length > 6 ? imp.id.substring(imp.id.length - 6).toUpperCase() : imp.id.toUpperCase();
          return ActivityCard(
            title: imp.title.isNotEmpty ? imp.title : imp.suggestion,
            id: shortId,
            timeAgo: imp.timeAgo,
            imageUrl: imp.mediaUrls.isNotEmpty ? imp.mediaUrls.first : null,
            accentColor: AppColors.improveBlue,
            accentColorLight: AppColors.improveBlue.withValues(alpha: 0.12),
            placeholderIcon: Icons.build_rounded,
            statusWidget: imp.department != null && imp.department!.isNotEmpty
                ? CategoryChip(label: imp.department!, color: AppColors.improveBlue)
                : null,
            onTap: () => Get.toNamed(Routes.improvementDetail, arguments: imp),
          );
        },
      );
    });
  }
}

class _AppreciationsTab extends StatelessWidget {
  final ActivityController controller;
  final EdgeInsets listPadding;
  const _AppreciationsTab({required this.controller, required this.listPadding});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final appreciations = controller.appreciations;
      if (appreciations.isEmpty) {
        return const SingleChildScrollView(child: _EmptyActivitySection());
      }
      return ListView.builder(
        padding: listPadding,
        itemCount: appreciations.length,
        itemBuilder: (_, i) {
          final a = appreciations[i];
          final shortId = a.id.length > 6 ? a.id.substring(a.id.length - 6).toUpperCase() : a.id.toUpperCase();
          return ActivityCard(
            title: a.staffName != null && a.staffName!.isNotEmpty
                ? a.staffName!
                : a.recipientCategory,
            id: shortId,
            timeAgo: a.timeAgo,
            accentColor: AppColors.appreciateGreen,
            accentColorLight: AppColors.appreciateGreenLight,
            placeholderIcon: Icons.favorite_rounded,
            statusWidget: CategoryChip(label: a.recipientCategory, color: AppColors.appreciateGreen),
            onTap: () => Get.toNamed(Routes.appreciationDetail, arguments: a),
          );
        },
      );
    });
  }
}
