import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/notification_model.dart';

part 'notification_api.g.dart';

@RestApi()
abstract class NotificationApi {
  factory NotificationApi(Dio dio, {String? baseUrl}) = _NotificationApi;

  @GET('/citizens/:citizenId/notifications')
  Future<List<NotificationModel>> getNotifications();

  @POST('/citizens/:citizenId/notifications/mark-as-read')
  Future<void> markAsRead(@Body() Map<String, dynamic> body);
}
