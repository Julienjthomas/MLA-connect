import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../data/models/appreciation_model.dart';
import '../../../data/models/idea_model.dart';
import '../../../data/models/office_message_model.dart';
import '../../../data/models/report_model.dart';
import '../../../data/services/appreciation_service.dart';
import '../../../data/services/idea_service.dart';
import '../../../data/services/office_messages_service.dart';
import '../../../data/services/report_service.dart';
import '../../auth/controllers/auth_controller.dart';

class ActivityController extends GetxController {
  final _reportService = ReportService();
  final _appreciationService = AppreciationService();
  final _ideaService = IdeaService();
  final _officeMessages = OfficeMessagesService();

  Worker? _profileWorker;

  final RxList<ReportModel> reports = <ReportModel>[].obs;
  final RxList<AppreciationModel> appreciations = <AppreciationModel>[].obs;
  final RxList<IdeaModel> ideas = <IdeaModel>[].obs;
  final RxList<OfficeMessageModel> officeMessages = <OfficeMessageModel>[].obs;
  final RxBool loading = false.obs;

  int get totalReports => reports.length;
  int get resolvedReports => reports.where((r) => r.status.name == 'resolved').length;
  int get totalAppreciations => appreciations.length;
  int get totalIdeas => ideas.length;
  int get totalOfficeMessages => officeMessages.length;

  @override
  void onInit() {
    super.onInit();
    final auth = Get.find<AuthController>();
    _profileWorker = ever(auth.user, (_) => loadActivity());
    loadActivity();
  }

  @override
  void onClose() {
    _profileWorker?.dispose();
    super.onClose();
  }

  Future<void> loadActivity() async {
    final auth = Get.find<AuthController>();
    final userId = auth.userId;
    if (userId == null) return;
    loading.value = true;
    try {
      final profile = auth.user.value;
      final cid = profile?.constituencyId;
      final reporterId = auth.submissionReporterId ?? '';
      final results = await Future.wait([
        if (reporterId.isNotEmpty)
          _reportService.getMyReports(reporterId: reporterId)
        else
          Future.value(const <ReportModel>[]),
        if (reporterId.isNotEmpty)
          _appreciationService.getMyAppreciations(reporterId: reporterId)
        else
          Future.value(const <AppreciationModel>[]),
        if (reporterId.isNotEmpty)
          _ideaService.getMyIdeas(reporterId: reporterId)
        else
          Future.value(const <IdeaModel>[]),
        _officeMessages.listForUser(userId: userId, constituencyId: cid, limit: 20),
      ]);
      reports.value = results[0] as List<ReportModel>;
      appreciations.value = results[1] as List<AppreciationModel>;
      ideas.value = results[2] as List<IdeaModel>;
      officeMessages.value = results[3] as List<OfficeMessageModel>;
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('[ActivityController] loadActivity failed: $e\n$st');
      }
    } finally {
      loading.value = false;
    }
  }
}
