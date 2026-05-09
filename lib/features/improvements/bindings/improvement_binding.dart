import 'package:get/get.dart';
import '../controllers/improvement_controller.dart';

class ImprovementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ImprovementController>(() => ImprovementController());
  }
}
