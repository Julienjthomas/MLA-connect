import 'package:get/get.dart';
import '../../activity/controllers/activity_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../updates/controllers/updates_controller.dart';

class ShellController extends GetxController {
  final RxInt currentIndex = 0.obs;

  void goTo(int index) {
    currentIndex.value = index;
    switch (index) {
      case 0:
        if (Get.isRegistered<HomeController>()) Get.find<HomeController>().loadData();
      case 1:
        if (Get.isRegistered<ActivityController>()) Get.find<ActivityController>().loadActivity();
      case 2:
        if (Get.isRegistered<UpdatesController>()) Get.find<UpdatesController>().loadUpdates();
    }
  }
}
