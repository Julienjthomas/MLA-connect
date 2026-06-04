## Why

Notifications are currently not implemented — no service exists. The new backend exposes `GET /citizens/:citizenId/notifications` and `POST mark-as-read`. Adding this now unblocks the notification bell UI and activity feed.

## What Changes

- Create `NotificationModel` (freezed) — id, title, body, type, isRead, createdAt
- Create `NotificationApi` retrofit client — GET notifications, POST mark-as-read
- Create `NotificationService` — wraps API calls
- Wire into `ActivityController` or a dedicated `NotificationsController`

## Capabilities

### New Capabilities

- `rest-notifications`: Fetch and mark-read citizen notifications via REST API

## Impact

- `lib/data/models/notification_model.dart` — new
- `lib/data/remote/notification_api.dart` — new retrofit client
- `lib/data/services/notification_service.dart` — new service
