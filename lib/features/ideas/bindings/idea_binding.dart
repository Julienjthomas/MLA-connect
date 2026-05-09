import 'package:get/get.dart';
import '../controllers/idea_controller.dart';

class IdeaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IdeaController>(() => IdeaController());
  }
}
