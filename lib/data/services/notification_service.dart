import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../models/citizen_notification.dart';

class NotificationService {
  Dio get _dio => Get.find<Dio>();

  Future<List<CitizenNotification>> getNotifications({int page = 1, int pageSize = 20}) async {
    try {
      final resp = await _dio.get(
        '/citizens/:citizenId/notifications',
        queryParameters: {'page': page, 'page_size': pageSize},
      );
      final body = resp.data;
      if (body is! Map<String, dynamic>) return [];
      final data = body['data'];
      if (data is! Map<String, dynamic>) return [];
      final items = data['items'];
      if (items is! List) return [];
      return items
          .whereType<Map<String, dynamic>>()
          .map(CitizenNotification.fromJson)
          .toList();
    } catch (e) {
      debugPrint('[NotificationService] getNotifications error: $e');
      return [];
    }
  }

  Future<int> getUnreadCount() async {
    try {
      final notifications = await getNotifications();
      return notifications.where((n) => !n.isRead).length;
    } catch (_) {
      return 0;
    }
  }

  Future<void> markAsRead(List<int> ids) async {
    if (ids.isEmpty) return;
    try {
      await _dio.put(
        '/citizens/:citizenId/notifications/read',
        data: {'notification_ids': ids},
      );
    } catch (e) {
      debugPrint('[NotificationService] markAsRead error: $e');
    }
  }
}
