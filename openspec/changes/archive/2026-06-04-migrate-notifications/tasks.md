## 1. Model

- [x] 1.1 Create `lib/data/models/notification_model.dart` — freezed: `{id, title, body, type, isRead, createdAt, data?}`
- [x] 1.2 Run `dart run build_runner build`

## 2. API Client

- [x] 2.1 Create `lib/data/remote/notification_api.dart` — retrofit: `GET /citizens/:citizenId/notifications`, `POST /citizens/:citizenId/notifications/mark-as-read`
- [x] 2.2 Run `dart run build_runner build`
- [x] 2.3 Register `NotificationApi` in DI in all 3 entry points

## 3. Service

- [x] 3.1 Create `lib/data/services/notification_service.dart` — `getNotifications()`, `markAsRead(List<String> ids)`

## 4. Verify

- [x] 4.1 Run `flutter analyze` — no errors
