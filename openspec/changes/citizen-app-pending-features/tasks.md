## 1. App Config Integration

- [x] 1.1 Add `GET /app-config` Retrofit method to `config_api.dart`
- [x] 1.2 Create `AppConfigModel` Freezed model for the config response
- [x] 1.3 Fetch app config in `main_dev.dart`, `main_stg.dart`, `main_prod.dart` before `runApp`; store result in `AppConfig` singleton
- [x] 1.4 Add fallback defaults to `AppConfig` for all feature flags
- [x] 1.5 Wire feature flag checks in shell/nav for gated features (leaderboard, conversations)

## 2. Media Upload — Presigned S3 URL Flow

- [x] 2.1 Add presigned URL Retrofit methods to concern, idea, and appreciation API files (confirm endpoint paths with backend)
- [x] 2.2 Create `MediaUploadService` with `uploadFile(File, entityType) → MediaPayload` method: (1) get presigned URL, (2) PUT to S3 via Dio, (3) return s3_key + metadata
- [ ] 2.3 Update `ReportController` to call `MediaUploadService` before submitting concern; replace placeholder s3_key logic
- [ ] 2.4 Update `IdeasController` to call `MediaUploadService` before submitting idea
- [ ] 2.5 Update `AppreciationController` to call `MediaUploadService` before submitting appreciation
- [ ] 2.6 Add error handling UI for presigned URL fetch failure and S3 upload failure in all three flows

## 3. Notifications UI

- [x] 3.1 Add `GET /citizens/notifications` and `PUT /citizens/notifications/read` Retrofit methods to `notification_api.dart` (verify they aren't already there)
- [x] 3.2 Create `NotificationService` wrapping the API with pagination support and batch mark-as-read
- [x] 3.3 Build `NotificationsView` screen: list with unread highlight, pull-to-refresh, empty state
- [x] 3.4 Wire tap handler to route by `target_type` (concern → concern detail, idea → idea detail, etc.)
- [x] 3.5 Mark all visible unread notifications as read on screen open
- [x] 3.6 Add notification badge to bottom nav shell; fetch unread count on shell init and after mark-as-read
- [x] 3.7 Register `/notifications` route in `app_routes.dart` and `app_pages.dart`

## 4. MLA Posts Feed

- [x] 4.1 Add `GET /constituencies/posts/recent`, `GET /constituencies/:id/posts`, `GET /constituencies/:id/posts/:postId`, `POST /constituencies/:id/posts/:postId/like` to `mla_api.dart`
- [x] 4.2 Verify `PostResponse` Freezed model in `lib/data/models/post/` matches API response; update if needed
- [x] 4.3 Create/update `PostService` with methods for recent posts, paginated feed, single post, like/unlike
- [x] 4.4 Add posts section to `HomeView` pulling from `GET /constituencies/posts/recent`
- [x] 4.5 Build `PostsFeedView` screen with paginated list and pull-to-refresh
- [x] 4.6 Build `PostDetailView` screen with full content, media, like button
- [x] 4.7 Register `/posts` and `/posts/detail` routes in `app_routes.dart` / `app_pages.dart`

## 5. Public Events Feed

- [x] 5.1 Add `GET /constituencies/public-events/upcoming`, `GET /constituencies/:id/public-events`, `GET /constituencies/:id/public-events/:eventId`, `POST /constituencies/:id/public-events/:eventId/show-interest` to `events_api.dart`
- [x] 5.2 Verify `PublicEventResponse` Freezed model in `lib/data/models/event/` matches API; update if needed
- [x] 5.3 Create/update `EventService` with upcoming, paginated, single event, show-interest methods
- [x] 5.4 Add upcoming events section to `HomeView`
- [x] 5.5 Build `EventsFeedView` screen (may already have shell — wire it to EventService)
- [x] 5.6 Build/update `EventDetailView` with full details and "Show Interest" button
- [x] 5.7 Register `/events` and `/events/detail` routes (verify existing routes in `app_routes.dart`)

## 6. Delete Account

- [x] 6.1 Add `DELETE /citizens/:citizenId/account` Retrofit method to `user_service.dart` or a dedicated `account_api.dart`
- [x] 6.2 Add "Delete Account" option in `ProfileView` settings section (destructive styling)
- [x] 6.3 Show confirmation bottom sheet/dialog with irreversibility warning and "Delete My Account" CTA
- [x] 6.4 On confirmation: call delete API, clear all tokens (FlutterSecureStorage + SharedPreferences), navigate to `/welcome`
- [x] 6.5 Handle API error: show error snackbar, do not clear session

## 7. Comments on Concerns, Ideas, Appreciations

- [x] 7.1 Add GET/POST/DELETE comment Retrofit methods to `concern_api.dart`, `idea_api.dart`, `appreciation_api.dart`
- [x] 7.2 Verify `ConcernComment`, `IdeaComment`, `AppreciationComment` Freezed models match API; update if needed
- [x] 7.3 Create `CommentWidget` — a reusable widget for displaying a single comment (avatar, name, text, timestamp, delete on long-press for own)
- [x] 7.4 Create `CommentsSection` widget with toggle, list of `CommentWidget`, compose input, and post action
- [x] 7.5 Add `CommentsSection` to concern detail screen (public board + own concern detail)
- [x] 7.6 Add `CommentsSection` to idea detail screen
- [x] 7.7 Add `CommentsSection` to appreciation detail screen
- [x] 7.8 Wire delete comment with confirmation dialog; decrement comment count on success

## 8. Conversations / Chat

- [x] 8.1 Add all conversation Retrofit methods to `conversations_api.dart`: create thread, list threads, get thread, send message, close thread
- [x] 8.2 Verify `ConversationThread` and `ConversationMessage` Freezed models match API; update if needed
- [x] 8.3 Create `ConversationService` wrapping all conversation API calls
- [x] 8.4 Build `ChatThreadListView` in `lib/features/chat/views/` — list threads, empty state, "Start conversation" button
- [x] 8.5 Build `ChatThreadDetailView` — message list (own right, staff left), compose bar, closed-thread banner
- [x] 8.6 Wire `ChatBinding` and `ChatController` to `ConversationService`
- [x] 8.7 Register `/chat` and `/chat/thread` routes (verify existing routes); connect bottom nav chat tab

## 9. Submission Controls (Visibility & Delete UI)

- [x] 9.1 Add visibility update API calls (if not already present) for concern, idea, appreciation
- [x] 9.2 Add visibility control widget (bottom sheet with 3 options) to concern detail screen for own submissions
- [x] 9.3 Add visibility control to idea detail screen for own submissions
- [x] 9.4 Add visibility control to appreciation detail screen for own submissions
- [x] 9.5 Add delete button (with confirmation dialog) to concern detail screen for own submissions
- [x] 9.6 Add delete button to idea detail screen for own submissions
- [x] 9.7 Add delete button to appreciation detail screen for own submissions
- [x] 9.8 On successful delete, pop back to list screen and remove item from list

## 10. Governance Limits

- [x] 10.1 Add ward last-changed date to citizen profile model; ensure it's returned from `GET /citizens/profile`
- [x] 10.2 In `ProfileEditController`, compute days remaining from `ward_updated_at`; expose as observable
- [x] 10.3 Disable ward selection field in profile edit if cool-off active; show remaining days label
- [x] 10.4 Exempt onboarding ward selection from cool-off check (check `isFirstTime` flag)
- [x] 10.5 In `ReportController.onStartFlow()`, call `GET /citizens/activity/summary` and check 24h concern count
- [x] 10.6 If count ≥ 2, show blocking dialog with reset time; abort flow
- [x] 10.7 Parse submission timestamps from activity summary to compute rolling 24h window reset time

## 11. Leaderboard & Badges

- [x] 11.1 Research/confirm leaderboard API endpoint; if unavailable, add feature flag gate from app-config
- [x] 11.2 Create leaderboard Retrofit method (or stub) in `mla_api.dart` or new `leaderboard_api.dart`
- [x] 11.3 Build `LeaderboardView` with ranked list, own citizen highlight, avatar, contribution count
- [x] 11.4 Define badge tier constants (Starter=1, Active=5, Champion=10, Leader=25, Legend=50)
- [x] 11.5 Build `BadgesWidget` for profile screen — display earned badges based on `contribution_count`
- [x] 11.6 Add `BadgesWidget` to `ProfileView`
- [x] 11.7 Increment local `contribution_count` in user state after each successful submission (concern, idea, appreciation)
- [x] 11.8 Register `/leaderboard` route; add entry point to home or achievements tab (gated by feature flag)
