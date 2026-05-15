import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../data/models/appreciation_model.dart';
import '../../../data/models/idea_model.dart';
import '../../../data/models/improvement_model.dart';
import '../../../data/models/office_message_model.dart';
import '../../../data/models/report_model.dart';
import '../../../data/services/appreciation_service.dart';
import '../../../data/services/idea_service.dart';
import '../../../data/services/improvement_service.dart';
import '../../../data/services/office_messages_service.dart';
import '../../../data/services/report_service.dart';
import '../../auth/controllers/auth_controller.dart';

class ActivityController extends GetxController {
  final _reportService = ReportService();
  final _appreciationService = AppreciationService();
  final _ideaService = IdeaService();
  final _improvementService = ImprovementService();
  final _officeMessages = OfficeMessagesService();

  Worker? _profileWorker;

  final RxList<ReportModel> reports = <ReportModel>[].obs;
  final RxList<AppreciationModel> appreciations = <AppreciationModel>[].obs;
  final RxList<IdeaModel> ideas = <IdeaModel>[].obs;
  final RxList<ImprovementModel> improvements = <ImprovementModel>[].obs;
  final RxList<OfficeMessageModel> officeMessages = <OfficeMessageModel>[].obs;
  final RxBool loading = false.obs;

  int get totalReports => reports.length;
  int get resolvedReports => reports.where((r) => r.status.name == 'resolved').length;
  int get totalAppreciations => appreciations.length;
  int get totalIdeas => ideas.length;
  int get totalImprovements => improvements.length;
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

    final reporterId = auth.user.value?.citizenRowId?.trim();
    if (reporterId == null || reporterId.isEmpty) return;

    loading.value = true;
    try {
      reports.value = await _loadList(
        _reportService.getMyReports(reporterId: reporterId),
        label: 'reports',
      );
      ideas.value = await _loadList(
        _ideaService.getMyIdeas(reporterId: reporterId),
        label: 'ideas',
      );
      improvements.value = await _loadList(
        _improvementService.getMyImprovements(reporterId: reporterId),
        label: 'improvements',
      );
      appreciations.value = await _loadList(
        _appreciationService.getMyAppreciations(reporterId: reporterId),
        label: 'appreciations',
      );
      final citizenId = int.tryParse(reporterId);
      final constituencyId = int.tryParse(auth.user.value?.constituencyId ?? '');
      if (citizenId != null && constituencyId != null) {
        officeMessages.value = await _loadList(
          _officeMessages.listForThread(citizenId: citizenId, constituencyId: constituencyId, limit: 20),
          label: 'office messages',
        );
      }
    } finally {
      loading.value = false;
    }
  }

  Future<List<T>> _loadList<T>(Future<List<T>> future, {required String label}) async {
    try {
      return await future;
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('[ActivityController] load $label failed: $e\n$st');
      }
      return <T>[];
    }
  }
}
