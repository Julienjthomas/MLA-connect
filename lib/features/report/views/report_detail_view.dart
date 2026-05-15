import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/kerala_app_bar.dart';
import '../../../core/widgets/shimmer_loader.dart';
import '../../../core/widgets/status_chip.dart';
import '../../../core/widgets/submission_media_image.dart';
import '../controllers/report_detail_controller.dart';

class ReportDetailView extends GetView<ReportDetailController> {
  const ReportDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const KeralaAppBar(title: 'Report Detail'),
      body: Obx(() {
        if (controller.loading.value) {
          return const Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                ShimmerBox(height: 40),
                SizedBox(height: 12),
                ShimmerBox(height: 20, borderRadius: 4),
                SizedBox(height: 20),
                ShimmerBox(height: 100),
                SizedBox(height: 20),
                ShimmerBox(height: 200),
              ],
            ),
          );
        }
        final report = controller.report.value;
        if (report == null) return const Center(child: Text('Report not found'));
        final description = report.description.trim();
        final title = report.title.trim();
        final showDescription = description.isNotEmpty && description != title;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text(title, style: AppTextStyles.headlineSmall)),
                  StatusChip(status: report.status),
                ],
              ),
              const SizedBox(height: 8),
              Text('ID: ${report.shortId}  •  ${report.wardName}', style: AppTextStyles.caption),
              const SizedBox(height: 4),
              Text(report.timeAgo, style: AppTextStyles.caption),
              if (showDescription) ...[
                const SizedBox(height: 16),
                Text(description, style: AppTextStyles.bodyMedium),
              ],
              if (report.mediaUrls.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text('Photos', style: AppTextStyles.titleSmall),
                const SizedBox(height: 8),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: report.mediaUrls.length,
                    itemBuilder: (_, i) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: SubmissionMediaImage(
                        reference: report.mediaUrls[i],
                        width: 100,
                        height: 100,
                        borderRadius: BorderRadius.circular(10),
                        placeholder: Container(
                          width: 100,
                          height: 100,
                          color: AppColors.grey200,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      }),
    );
  }
}
