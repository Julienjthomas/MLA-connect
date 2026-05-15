import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_enums.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/activity_card.dart';
import '../../../core/widgets/activity_empty_state.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/shimmer_loader.dart';
import '../../../core/widgets/submission_media_image.dart';
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
            Text(AppStrings.trackContributions, style: AppTextStyles.caption),
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
              return FloatingActionButton.extended(
                onPressed: () => _openAddFlow(tab),
                backgroundColor: addFeature.color,
                icon: Icon(addFeature.icon, color: Colors.white),
                label: Text(addLabel, style: const TextStyle(color: Colors.white)),
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
              tabs: _tabs.map((t) => Tab(text: t.label)).toList(),
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
                    const Text('👋 ', style: TextStyle(fontSize: 16)),
                    Text(
                      'Great going${firstName.isNotEmpty ? ', $firstName' : ''}!',
                      style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '$total ',
                        style: AppTextStyles.headlineLarge.copyWith(color: AppColors.primary, height: 1),
                      ),
                      TextSpan(
                        text: 'contributions so far',
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'You\'re helping build a better community.',
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.emoji_events_rounded, color: AppColors.primary, size: 34),
          ),
        ],
      ),
    );
  }
}

class _FilterChips extends StatefulWidget {
  final Widget Function(SubmissionStatus? filter) builder;

  const _FilterChips({required this.builder});

  @override
  State<_FilterChips> createState() => _FilterChipsState();
}

class _FilterChipsState extends State<_FilterChips> {
  SubmissionStatus? _filter;

  static const _options = <(String, SubmissionStatus?)>[
    ('All', null),
    ('Active', SubmissionStatus.inProgress),
    ('Resolved', SubmissionStatus.resolved),
    ('Closed', SubmissionStatus.rejected),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 44,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: _options.map((opt) {
              final (label, value) = opt;
              final selected = _filter == value;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(label),
                  selected: selected,
                  onSelected: (_) => setState(() => _filter = value),
                  selectedColor: AppColors.primary.withValues(alpha: 0.12),
                  labelStyle: AppTextStyles.labelMedium.copyWith(
                    color: selected ? AppColors.primary : AppColors.grey500,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: selected ? AppColors.primary : AppColors.grey200,
                    ),
                  ),
                  backgroundColor: AppColors.surface,
                  showCheckmark: false,
                ),
              );
            }).toList(),
          ),
        ),
        widget.builder(_filter),
      ],
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
        return const ActivityEmptyState(tab: ActivityTab.reports);
      }
      return _FilterChips(
        builder: (filter) {
          final filtered = filter == null
              ? reports
              : reports.where((r) => r.status == filter).toList();
          if (filtered.isEmpty) {
            return const Expanded(
              child: EmptyState(
                title: 'No matches',
                message: 'No reports with this status.',
              ),
            );
          }
          return Expanded(
            child: ListView.builder(
              padding: listPadding,
              itemCount: filtered.length,
              itemBuilder: (_, i) {
                final r = filtered[i];
                return ActivityCard(
                  title: r.title,
                  id: r.shortId,
                  ward: r.wardName,
                  status: r.status,
                  timeAgo: r.timeAgo,
                  imageUrl: r.mediaUrls.isNotEmpty ? r.mediaUrls.first : null,
                  onTap: () => Get.toNamed(Routes.reportDetail, arguments: r.id),
                );
              },
            ),
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
        return const ActivityEmptyState(tab: ActivityTab.ideas);
      }
      return ListView.builder(
        padding: listPadding,
        itemCount: ideas.length,
        itemBuilder: (_, i) {
          final idea = ideas[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.grey200),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: idea.mediaUrls.isNotEmpty
                      ? SubmissionMediaImage(
                          reference: idea.mediaUrls.first,
                          width: 44,
                          height: 44,
                          placeholder: Container(
                            width: 44,
                            height: 44,
                            color: AppColors.ideaPurpleLight,
                            alignment: Alignment.center,
                            child: const Icon(Icons.lightbulb_rounded, color: AppColors.ideaPurple, size: 22),
                          ),
                        )
                      : Container(
                          width: 44,
                          height: 44,
                          color: AppColors.ideaPurpleLight,
                          alignment: Alignment.center,
                          child: const Icon(Icons.lightbulb_rounded, color: AppColors.ideaPurple, size: 22),
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(idea.title, style: AppTextStyles.titleSmall, maxLines: 2, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Text(idea.topic, style: AppTextStyles.caption.copyWith(color: AppColors.ideaPurple)),
                      const SizedBox(height: 4),
                      Text(idea.timeAgo, style: AppTextStyles.caption),
                    ],
                  ),
                ),
              ],
            ),
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
        return const ActivityEmptyState(tab: ActivityTab.improvements);
      }
      return ListView.builder(
        padding: listPadding,
        itemCount: improvements.length,
        itemBuilder: (_, i) {
          final improvement = improvements[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.grey200),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: improvement.mediaUrls.isNotEmpty
                      ? SubmissionMediaImage(
                          reference: improvement.mediaUrls.first,
                          width: 44,
                          height: 44,
                          placeholder: Container(
                            width: 44,
                            height: 44,
                            color: AppColors.improveBlue.withValues(alpha: 0.12),
                            alignment: Alignment.center,
                            child: const Icon(Icons.tips_and_updates_outlined, color: AppColors.improveBlue, size: 22),
                          ),
                        )
                      : Container(
                          width: 44,
                          height: 44,
                          color: AppColors.improveBlue.withValues(alpha: 0.12),
                          alignment: Alignment.center,
                          child: const Icon(Icons.tips_and_updates_outlined, color: AppColors.improveBlue, size: 22),
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        improvement.title.isNotEmpty ? improvement.title : improvement.suggestion,
                        style: AppTextStyles.titleSmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (improvement.department != null && improvement.department!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(improvement.department!, style: AppTextStyles.caption.copyWith(color: AppColors.improveBlue)),
                      ],
                      const SizedBox(height: 4),
                      Text(improvement.timeAgo, style: AppTextStyles.caption),
                    ],
                  ),
                ),
              ],
            ),
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
        return const ActivityEmptyState(tab: ActivityTab.appreciations);
      }
      return ListView.builder(
        padding: listPadding,
        itemCount: appreciations.length,
        itemBuilder: (_, i) {
          final a = appreciations[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
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
                  decoration: BoxDecoration(
                    color: AppColors.appreciateGreenLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.favorite_rounded, color: AppColors.appreciateGreen, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(a.recipientCategory, style: AppTextStyles.titleSmall),
                      if (a.staffName != null && a.staffName!.isNotEmpty)
                        Text(a.staffName!, style: AppTextStyles.caption.copyWith(color: AppColors.appreciateGreen)),
                      const SizedBox(height: 4),
                      Text(a.visibility.label, style: AppTextStyles.caption),
                      Text(a.timeAgo, style: AppTextStyles.caption),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }
}
