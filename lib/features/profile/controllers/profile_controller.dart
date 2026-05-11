import 'package:get/get.dart';
import '../../../features/auth/controllers/auth_controller.dart';

class ProfileController extends GetxController {
  final _auth = Get.find<AuthController>();

  final RxBool notifyIssueUpdates = true.obs;
  final RxBool notifyMlaAnnouncements = true.obs;
  final RxBool notifyEmergencyAlerts = true.obs;
  final RxBool notifyEventReminders = false.obs;

  String get userName => _auth.user.value?.name ?? 'User';
  String? get userPhone => _auth.user.value?.phone;
  String? get userAvatar => _auth.user.value?.avatarUrl;
  String? get wardName => _auth.user.value?.wardName;
  String? get localBodyName => _auth.user.value?.localBodyName;

  Future<void> logout() => _auth.logout();
}
