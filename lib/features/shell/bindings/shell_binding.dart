import 'package:get/get.dart';
import '../controllers/shell_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../activity/controllers/activity_controller.dart';
import '../../updates/controllers/updates_controller.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../chat/controllers/chat_controller.dart';

class ShellBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShellController>(() => ShellController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<ChatController>(() => ChatController());
    Get.lazyPut<ActivityController>(() => ActivityController());
    Get.lazyPut<UpdatesController>(() => UpdatesController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
