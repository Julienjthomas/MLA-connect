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
    loadActivity();
  }

  Future<void> loadActivity() async {
    final auth = Get.find<AuthController>();
    final userId = auth.userId;
    if (userId == null) return;
    final reporterId = auth.submissionReporterId;
    if (reporterId == null) return;
    loading.value = true;
    try {
      final cid = auth.user.value?.constituencyId;
      final results = await Future.wait([
        _reportService.getMyReports(reporterId),
        _appreciationService.getMyAppreciations(reporterId),
        _ideaService.getMyIdeas(reporterId),
        _officeMessages.listForUser(userId: userId, constituencyId: cid, limit: 20),
      ]);
      reports.value = results[0] as List<ReportModel>;
      appreciations.value = results[1] as List<AppreciationModel>;
      ideas.value = results[2] as List<IdeaModel>;
      officeMessages.value = results[3] as List<OfficeMessageModel>;
    } catch (_) {} finally {
      loading.value = false;
    }
  }
}
