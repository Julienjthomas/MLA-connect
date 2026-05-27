import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../routes/app_routes.dart';
import '../controllers/home_controller.dart';

class EventsListView extends StatelessWidget {
  const EventsListView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<HomeController>() ? Get.find<HomeController>() : Get.put(HomeController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Events', style: AppTextStyles.titleMedium),
      ),
      body: Obx(() {
        final events = controller.upcomingEvents;
        if (events.isEmpty) {
          return const EmptyState(
            title: 'No upcoming events',
            message: 'Events and programmes will appear here when scheduled.',
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: events.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, i) {
            final e = events[i];
            return GestureDetector(
              onTap: () => Get.toNamed(Routes.eventDetail, arguments: e.id),
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
                      child: const Icon(Icons.event_rounded, color: AppColors.primary, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(e.title, style: AppTextStyles.titleSmall),
                          const SizedBox(height: 2),
                          Text(e.formattedTime, style: AppTextStyles.caption),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary, size: 20),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
