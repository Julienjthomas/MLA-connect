import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_enums.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/activity_card.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/shimmer_loader.dart';
import '../../../core/widgets/submission_media_image.dart';
import '../../../routes/app_routes.dart';
import '../controllers/activity_controller.dart';

class ActivityView extends GetView<ActivityController> {
  const ActivityView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
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
    final tab = ActivityTab.values[_tabController?.index ?? 0];
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
        bottom: TabBar(
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.grey500,
          labelStyle: AppTextStyles.labelMedium,
          tabs: ActivityTab.values.map((t) => Tab(text: t.label)).toList(),
        ),
      ),
      floatingActionButton: addFeature == null || addLabel == null
          ? null
          : FloatingActionButton.extended(
              onPressed: () => _openAddFlow(tab),
              backgroundColor: addFeature.color,
              icon: Icon(addFeature.icon, color: Colors.white),
              label: Text(addLabel, style: const TextStyle(color: Colors.white)),
            ),
      body: Column(
        children: [
          Obx(
            () => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _SummaryCards(
                  reports: widget.controller.totalReports,
                  resolved: widget.controller.resolvedReports,
                  appreciations: widget.controller.totalAppreciations,
                  ideas: widget.controller.totalIdeas,
                  improvements: widget.controller.totalImprovements,
                  officeMessages: widget.controller.totalOfficeMessages,
                ),
                if (widget.controller.officeMessages.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Office messages are listed in the Chat tab.',
                        style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                      ),
                    ),
                  ),
              ],
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
                  _SavedTab(),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _SummaryCards extends StatelessWidget {
  final int reports, resolved, appreciations, ideas, improvements, officeMessages;
  const _SummaryCards({
    required this.reports,
    required this.resolved,
    required this.appreciations,
    required this.ideas,
    required this.improvements,
    required this.officeMessages,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            _stat('$reports', 'Reports', AppColors.reportOrange, Icons.report_outlined),
            _stat('$resolved', 'Resolved', AppColors.appreciateGreen, Icons.check_circle_outline),
            _stat('$ideas', 'Ideas', AppColors.ideaPurple, Icons.lightbulb_outline),
            _stat('$improvements', 'Improve-\nments', AppColors.improveBlue, Icons.tips_and_updates_outlined),
            _stat('$appreciations', 'Thanks', AppColors.appreciateGreen, Icons.favorite_outline),
            _stat('$officeMessages', 'Office\nChat', AppColors.primary, Icons.chat_outlined),
          ],
        ),
      ),
    );
  }

  Widget _stat(String value, String label, Color color, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.12), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 6),
          Text(value, style: AppTextStyles.titleMedium.copyWith(color: color)),
          const SizedBox(height: 2),
          Text(label, style: AppTextStyles.caption, textAlign: TextAlign.center),
        ],
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
        return EmptyState(
          title: 'No reports yet',
          message: 'You haven\'t submitted any reports. Tap "Report Problem" on the home screen to get started.',
          actionLabel: 'Report a Problem',
          onAction: () => Get.toNamed(Routes.reportFlow),
        );
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
        return EmptyState(
          title: 'No ideas yet',
          message: 'Share your ideas to improve your constituency!',
          actionLabel: 'Share an Idea',
          onAction: () => Get.toNamed(Routes.ideasFlow),
        );
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
        return EmptyState(
          title: 'No improvements yet',
          message: 'Suggest practical improvements for your constituency.',
          actionLabel: 'Suggest Improvement',
          onAction: () => Get.toNamed(Routes.improvementsFlow),
        );
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
        return EmptyState(
          title: 'No appreciations yet',
          message: 'Recognize good work by government staff!',
          actionLabel: 'Send Appreciation',
          onAction: () => Get.toNamed(Routes.appreciationFlow),
        );
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

class _SavedTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const EmptyState(
      title: 'Nothing saved yet',
      message: 'Bookmark updates and reports to find them here later.',
    );
  }
}
