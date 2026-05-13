import 'package:get/get.dart';
import '../../activity/controllers/activity_controller.dart';

class ShellController extends GetxController {
  final RxInt currentIndex = 0.obs;

  void goTo(int index) {
    currentIndex.value = index;
    if (index == 2 && Get.isRegistered<ActivityController>()) {
      Get.find<ActivityController>().loadActivity();
    }
  }
}
