import 'package:get/get.dart';
import '../../../data/models/report_model.dart';
import '../../../data/services/report_service.dart';

class ReportDetailController extends GetxController {
  final Rx<ReportModel?> report = Rx(null);
  final RxBool loading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    final id = Get.arguments as String?;
    if (id == null) { loading.value = false; return; }
    try {
      report.value = await ReportService().getReport(id);
    } catch (_) {}
    loading.value = false;
  }
}
