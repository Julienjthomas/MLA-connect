import 'package:get/get.dart';
import '../../../data/models/mla_model.dart';
import '../../../data/services/mla_service.dart';
import '../../auth/controllers/auth_controller.dart';

class MlaController extends GetxController {
  final _service = MlaService();
  final Rx<MlaModel?> mla = Rx(null);
  final RxBool loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    loading.value = true;
    try {
      final cid = Get.find<AuthController>().user.value?.constituencyId;
      mla.value = await _service.getMlaProfile(constituencyId: cid);
    } finally {
      loading.value = false;
    }
  }
}
