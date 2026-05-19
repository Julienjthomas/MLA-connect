import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controllers/home_controller.dart';

class EventsListView extends StatelessWidget {
  const EventsListView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<HomeController>() ? Get.find<HomeController>() : Get.put(HomeController());
    final events = controller.grievanceEvents;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text('Events', style: AppTextStyles.titleMedium),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: events.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) {
          final e = events[i];
          return Container(
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
                      Text(e['title']!, style: AppTextStyles.titleSmall),
                      const SizedBox(height: 2),
                      Text(e['date']!, style: AppTextStyles.caption),
                      Text(e['venue']!, style: AppTextStyles.caption),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
