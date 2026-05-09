import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class TimelineEvent {
  final String date;
  final String title;
  final String subtitle;
  final bool isCompleted;

  const TimelineEvent({
    required this.date,
    required this.title,
    required this.subtitle,
    this.isCompleted = true,
  });
}

class TimelineWidget extends StatelessWidget {
  final List<TimelineEvent> events;
  final Color? accentColor;

  const TimelineWidget({super.key, required this.events, this.accentColor});

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? AppColors.primary;
    return Column(
      children: events.asMap().entries.map((e) {
        final isLast = e.key == events.length - 1;
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    margin: const EdgeInsets.only(top: 2),
                    decoration: BoxDecoration(
                      color: e.value.isCompleted ? color : AppColors.grey300,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: e.value.isCompleted
                        ? const Icon(Icons.check, color: Colors.white, size: 8)
                        : null,
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(width: 2, color: AppColors.grey200),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(e.value.date, style: AppTextStyles.caption),
                      const SizedBox(height: 2),
                      Text(e.value.title, style: AppTextStyles.titleSmall),
                      const SizedBox(height: 2),
                      Text(e.value.subtitle, style: AppTextStyles.bodySmall),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
