import 'package:get/get.dart';
import '../../../data/services/user_service.dart';
import '../../../features/onboarding/controllers/onboarding_controller.dart';
import '../../../routes/app_routes.dart';
import 'auth_controller.dart';

class NotificationsSetupController extends GetxController {
  final RxBool issueUpdates = true.obs;
  final RxBool mlaAnnouncements = true.obs;
  final RxBool emergencyAlerts = true.obs;
  final RxBool eventReminders = false.obs;
  final RxBool loading = false.obs;

  Future<void> finish() async {
    loading.value = true;
    try {
      final userId = Get.find<AuthController>().userId;
      if (userId != null) {
        await UserService().saveNotificationPrefs(userId, {
          'issue_updates': issueUpdates.value,
          'mla_announcements': mlaAnnouncements.value,
          'emergency_alerts': emergencyAlerts.value,
          'event_reminders': eventReminders.value,
        });
      }
      Get.delete<OnboardingController>(force: true);
      Get.offAllNamed(Routes.onboardingSuccess);
    } catch (_) {
      Get.delete<OnboardingController>(force: true);
      Get.offAllNamed(Routes.onboardingSuccess);
    } finally {
      loading.value = false;
    }
  }
}
