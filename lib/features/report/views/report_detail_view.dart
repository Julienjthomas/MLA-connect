import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/kerala_app_bar.dart';
import '../../../core/widgets/status_chip.dart';
import '../../../core/widgets/timeline_widget.dart';
import '../../../data/models/report_model.dart';
import '../../../data/services/report_service.dart';

class ReportDetailView extends StatefulWidget {
  const ReportDetailView({super.key});

  @override
  State<ReportDetailView> createState() => _ReportDetailViewState();
}

class _ReportDetailViewState extends State<ReportDetailView> {
  ReportModel? report;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final id = Get.arguments as String?;
    if (id == null) return;
    try {
      report = await ReportService().getReport(id);
    } catch (_) {}
    if (mounted) setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const KeralaAppBar(title: 'Report Detail'),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : report == null
              ? const Center(child: Text('Report not found'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Expanded(child: Text(report!.title, style: AppTextStyles.headlineSmall)),
                        StatusChip(status: report!.status),
                      ]),
                      const SizedBox(height: 8),
                      Text('ID: ${report!.shortId}  •  ${report!.wardName}', style: AppTextStyles.caption),
                      const SizedBox(height: 4),
                      Text(report!.timeAgo, style: AppTextStyles.caption),
                      const SizedBox(height: 16),
                      Text(report!.description, style: AppTextStyles.bodyMedium),
                      if (report!.mediaUrls.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Text('Photos', style: AppTextStyles.titleSmall),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: report!.mediaUrls.length,
                            itemBuilder: (_, i) => Container(
                              width: 100, height: 100,
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.grey200,
                                image: DecorationImage(image: NetworkImage(report!.mediaUrls[i]), fit: BoxFit.cover),
                              ),
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      Text('Status Timeline', style: AppTextStyles.titleSmall),
                      const SizedBox(height: 12),
                      TimelineWidget(events: report!.timeline, accentColor: AppColors.reportOrange),
                    ],
                  ),
                ),
    );
  }
}
