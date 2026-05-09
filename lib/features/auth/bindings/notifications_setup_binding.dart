import 'package:get/get.dart';

import '../controllers/notifications_setup_controller.dart';

class NotificationsSetupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationsSetupController>(() => NotificationsSetupController());
  }
}

