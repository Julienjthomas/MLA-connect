import 'package:get/get.dart';
import '../../../data/models/report_model.dart';
import '../../../data/remote/concern_api.dart';
import '../../../data/services/report_service.dart';
import '../../auth/controllers/auth_controller.dart';

class ReportDetailController extends GetxController {
  final Rx<ReportModel?> report = Rx(null);
  final RxBool loading = true.obs;
  final RxBool deleting = false.obs;

  bool get isOwn {
    final uid = Get.find<AuthController>().userId;
    return uid != null && report.value?.userId == uid;
  }

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    final args = Get.arguments;
    final id = args is String ? args : (args is Map ? args['id'] as String? : null);
    if (id == null) {
      loading.value = false;
      return;
    }
    try {
      report.value = await ReportService().getReport(id);
    } catch (_) {}
    loading.value = false;
  }

  Future<void> deleteReport() async {
    final id = report.value?.id;
    if (id == null) return;
    deleting.value = true;
    try {
      await Get.find<ConcernApi>().deleteConcern(id);
      Get.back(result: true);
    } catch (_) {
      Get.snackbar('Error', 'Could not delete. Try again.', snackPosition: SnackPosition.BOTTOM);
    } finally {
      deleting.value = false;
    }
  }
}

// Visibility update is done via PATCH/PUT on the concern endpoint.
// Wire in when backend confirms the update endpoint path.

