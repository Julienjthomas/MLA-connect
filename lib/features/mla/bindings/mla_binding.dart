import 'package:get/get.dart';
import '../controllers/mla_controller.dart';

class MlaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MlaController>(() => MlaController());
  }
}
