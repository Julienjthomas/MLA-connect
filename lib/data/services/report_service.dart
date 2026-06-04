import 'package:get/get.dart';

import '../../core/constants/app_enums.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/widgets/timeline_widget.dart';
import '../models/concern/concern_model.dart';
import '../models/concern/create_concern_request.dart';
import '../models/report_model.dart';
import '../remote/concern_api.dart';

class ReportService {
  ConcernApi get _api => Get.find<ConcernApi>();

  Future<List<ReportModel>> getMyReports() async {
    final concerns = await _api.getMyConcerns();
    return concerns.where((c) => c.category == 'report' || c.category == 'problem').map(_mapToReport).toList();
  }

  Future<ReportModel?> getReport(String id) async {
    try {
      final concern = await _api.getConcern(id);
      return _mapToReport(concern);
    } catch (_) {
      return null;
    }
  }

  Future<String> submitReport(ReportFormData data, String userId) async {
    final concern = await _api.createConcern(
      CreateConcernRequest(
        category: data.category.name,
        title: data.title,
        description: data.description,
        location: data.location,
        landmark: data.landmark,
        voiceNoteUrl: data.voiceMessageUrl,
        wardId: data.wardId,
        contactNumber: data.contactNumber,
        mediaUrls: data.mediaUrls,
      ),
    );
    return concern.id;
  }

  ReportModel _mapToReport(ConcernModel c) => ReportModel(
    id: c.id,
    userId: c.citizenId,
    category: ReportCategoryX.fromString(c.category),
    title: c.title,
    description: c.description,
    voiceNoteUrl: c.voiceNoteUrl,
    location: c.location ?? '',
    landmark: c.landmark,
    wardId: c.wardId ?? '',
    wardName: c.wardName ?? '',
    contactNumber: c.contactNumber,
    status: SubmissionStatusX.fromString(c.status),
    createdAt: c.createdAt,
    mediaUrls: c.mediaUrls,
    timeline: c.timeline
        .map(
          (t) => TimelineEvent(
            date: DateFormatter.shortDate(t.createdAt),
            title: SubmissionStatusX.fromString(t.status).label,
            subtitle: t.notes ?? '',
          ),
        )
        .toList(),
  );
}
