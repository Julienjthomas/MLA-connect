import 'package:get/get.dart';

import '../../../data/models/citizen_notification.dart';
import '../../../data/services/notification_service.dart';
import '../../../routes/app_routes.dart';

class NotificationsController extends GetxController {
  final _service = NotificationService();

  final RxList<CitizenNotification> notifications = <CitizenNotification>[].obs;
  final RxBool loading = false.obs;
  final RxInt unreadCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    loading.value = true;
    try {
      final items = await _service.getNotifications();
      notifications.value = items;
      unreadCount.value = items.where((n) => !n.isRead).length;
      _markVisibleAsRead(items);
    } finally {
      loading.value = false;
    }
  }

  void _markVisibleAsRead(List<CitizenNotification> items) {
    final unreadIds = items.where((n) => !n.isRead).map((n) => n.id).toList();
    if (unreadIds.isNotEmpty) {
      _service.markAsRead(unreadIds);
    }
  }

  void onNotificationTap(CitizenNotification n) {
    switch (n.targetType) {
      case 'concern':
        Get.toNamed(Routes.reportDetail, arguments: {'id': n.targetId?.toString()});
      case 'idea':
        Get.toNamed(Routes.ideaDetail, arguments: {'id': n.targetId?.toString()});
      case 'appreciation':
        Get.toNamed(Routes.appreciationDetail, arguments: {'id': n.targetId?.toString()});
      default:
        break;
    }
  }
}
