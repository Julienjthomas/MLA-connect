import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          padding: EdgeInsets.all(16.r),
          itemCount: events.length,
          separatorBuilder: (_, __) => SizedBox(height: 12.h),
          itemBuilder: (_, i) {
            final e = events[i];
            return GestureDetector(
              onTap: () => Get.toNamed(Routes.eventDetail, arguments: e.id),
              child: Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: AppColors.grey200),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40.r,
                      height: 40.r,
                      decoration: BoxDecoration(color: AppColors.ideaPurpleLight, borderRadius: BorderRadius.circular(10.r)),
                      child: Icon(Icons.event_rounded, color: AppColors.primary, size: 22.r),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(e.title, style: AppTextStyles.titleSmall),
                          SizedBox(height: 2.h),
                          Text(e.formattedTime, style: AppTextStyles.caption),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary, size: 20.r),
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
