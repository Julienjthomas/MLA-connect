import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_enums.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../../routes/app_routes.dart';
import 'action_card.dart';
import 'primary_button.dart';

class ActivityEmptyState extends StatelessWidget {
  final ActivityTab tab;

  const ActivityEmptyState({super.key, required this.tab});

  static const _contentTabs = [
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
    final others = _contentTabs.where((t) => t != tab).toList();

    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Start contributing to your community',
                  style: AppTextStyles.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Report issues, share ideas and track updates from your constituency.',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textTertiary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                PrimaryButton(
                  text: tab.addActionLabel!,
                  onPressed: () => Get.toNamed(_routeFor(tab)),
                ),
                const SizedBox(height: 16),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (int i = 0; i < others.length; i++) ...[
                        if (i > 0) const SizedBox(width: 8),
                        Expanded(
                          child: ActionCard(
                            icon: others[i].addFeature!.icon,
                            title: others[i].addFeature!.label,
                            subtitle: others[i].addFeature!.subtitle,
                            accentColor: others[i].addFeature!.color,
                            onTap: () => Get.toNamed(_routeFor(others[i])),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
