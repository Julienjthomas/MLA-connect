import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_enums.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/activity_card.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/shimmer_loader.dart';
import '../../../routes/app_routes.dart';
import '../controllers/activity_controller.dart';

class ActivityView extends GetView<ActivityController> {
  const ActivityView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          leading: const SizedBox.shrink(),
          centerTitle: false,
          leadingWidth: 0,
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppStrings.myActivity, style: AppTextStyles.titleLarge),
              Text(AppStrings.trackContributions, style: AppTextStyles.caption),
            ],
          ),
          actions: const [],
          bottom: TabBar(
            isScrollable: false,
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.grey500,
            labelStyle: AppTextStyles.labelMedium,
            tabs: ActivityTab.values.map((t) => Tab(text: t.label)).toList(),
          ),
        ),
        body: Column(
          children: [
            // Summary cards
            Obx(
              () => _SummaryCards(
                reports: controller.totalReports,
                resolved: controller.resolvedReports,
                appreciations: controller.totalAppreciations,
                ideas: controller.totalIdeas,
              ),
            ),
            // Tab content
            Expanded(
              child: Obx(() {
                if (controller.loading.value) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: 4,
                    itemBuilder: (_, __) => const ShimmerCard(),
                  );
                }
                return TabBarView(
                  children: [
                    _ReportsTab(controller: controller),
                    _IdeasTab(controller: controller),
                    _AppreciationsTab(controller: controller),
                    _SavedTab(),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCards extends StatelessWidget {
  final int reports, resolved, appreciations, ideas;
  const _SummaryCards({
    required this.reports,
    required this.resolved,
    required this.appreciations,
    required this.ideas,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _stat('$reports', 'Reports\nSubmitted', AppColors.reportOrange, Icons.report_outlined),
          _stat('$resolved', 'Resolved\nIssues', AppColors.appreciateGreen, Icons.check_circle_outline),
          _stat('$ideas', 'Ideas\nShared', AppColors.ideaPurple, Icons.lightbulb_outline),
          _stat('$appreciations', 'Appreciations\nSent', AppColors.improveBlue, Icons.favorite_outline),
        ],
      ),
    );
  }

  Widget _stat(String value, String label, Color color, IconData icon) {
    return Column(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(color: color.withValues(alpha: 0.12), shape: BoxShape.circle),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(height: 6),
        Text(value, style: AppTextStyles.titleLarge.copyWith(color: color)),
        Text(label, style: AppTextStyles.caption.copyWith(height: 1.2), textAlign: TextAlign.center),
      ],
    );
  }
}

class _ReportsTab extends StatelessWidget {
  final ActivityController controller;
  const _ReportsTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    if (controller.reports.isEmpty) {
      return EmptyState(
        title: 'No reports yet',
        message: 'You haven\'t submitted any reports. Tap "Report Problem" on the home screen to get started.',
        actionLabel: 'Report a Problem',
        onAction: () => Get.toNamed(Routes.reportFlow),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.reports.length,
      itemBuilder: (_, i) {
        final r = controller.reports[i];
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
  }
}

class _IdeasTab extends StatelessWidget {
  final ActivityController controller;
  const _IdeasTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    if (controller.ideas.isEmpty) {
      return EmptyState(
        title: 'No ideas yet',
        message: 'Share your ideas to improve Balussery!',
        actionLabel: 'Share an Idea',
        onAction: () => Get.toNamed(Routes.ideasFlow),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.ideas.length,
      itemBuilder: (_, i) {
        final idea = controller.ideas[i];
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
                decoration: BoxDecoration(color: AppColors.ideaPurpleLight, borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.lightbulb_rounded, color: AppColors.ideaPurple, size: 22),
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
  }
}

class _AppreciationsTab extends StatelessWidget {
  final ActivityController controller;
  const _AppreciationsTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    if (controller.appreciations.isEmpty) {
      return EmptyState(
        title: 'No appreciations yet',
        message: 'Recognize good work by government staff!',
        actionLabel: 'Send Appreciation',
        onAction: () => Get.toNamed(Routes.appreciationFlow),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.appreciations.length,
      itemBuilder: (_, i) {
        final a = controller.appreciations[i];
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
