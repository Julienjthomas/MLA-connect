import 'package:get/get.dart';
import '../controllers/appreciation_controller.dart';

class AppreciationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppreciationController>(() => AppreciationController());
  }
}
