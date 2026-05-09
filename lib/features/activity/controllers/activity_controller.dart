import 'package:get/get.dart';
import '../../../data/models/appreciation_model.dart';
import '../../../data/models/idea_model.dart';
import '../../../data/models/report_model.dart';
import '../../../data/services/appreciation_service.dart';
import '../../../data/services/idea_service.dart';
import '../../../data/services/report_service.dart';
import '../../auth/controllers/auth_controller.dart';

class ActivityController extends GetxController {
  final _reportService = ReportService();
  final _appreciationService = AppreciationService();
  final _ideaService = IdeaService();

  final RxList<ReportModel> reports = <ReportModel>[].obs;
  final RxList<AppreciationModel> appreciations = <AppreciationModel>[].obs;
  final RxList<IdeaModel> ideas = <IdeaModel>[].obs;
  final RxBool loading = false.obs;

  // Summary stats
  int get totalReports => reports.length;
  int get resolvedReports => reports.where((r) => r.status.name == 'resolved').length;
  int get totalAppreciations => appreciations.length;
  int get totalIdeas => ideas.length;

  @override
  void onInit() {
    super.onInit();
    loadActivity();
  }

  Future<void> loadActivity() async {
    final userId = Get.find<AuthController>().userId;
    if (userId == null) return;
    loading.value = true;
    try {
      final results = await Future.wait([
        _reportService.getMyReports(userId),
        _appreciationService.getMyAppreciations(userId),
        _ideaService.getMyIdeas(userId),
      ]);
      reports.value = results[0] as List<ReportModel>;
      appreciations.value = results[1] as List<AppreciationModel>;
      ideas.value = results[2] as List<IdeaModel>;
    } catch (_) {} finally {
      loading.value = false;
    }
  }
}
