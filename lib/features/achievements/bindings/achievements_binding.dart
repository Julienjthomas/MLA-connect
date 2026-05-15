import 'package:get/get.dart';
import '../controllers/achievements_controller.dart';

class AchievementsBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AchievementsController>()) {
      Get.lazyPut<AchievementsController>(() => AchievementsController());
    }
  }
}
