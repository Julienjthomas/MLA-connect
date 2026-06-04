## Why

The MLA Connect citizen app has a working foundation (auth, onboarding, submissions) but is missing the features defined as pending in the product pitch, plus several API contracts remain unintegrated — leaving the app unable to display MLA posts, public events, comments, or support real media uploads. Implementing these closes the gap between what's built and what the pitch promises.

## What Changes

- **App Config on startup**: Fetch `GET /app-config` at launch and apply remote flags before rendering
- **Real media uploads**: Integrate presigned URL flow (get URL → upload to S3 → submit with `s3_key`) for concerns, ideas, and appreciations — currently media is sent with placeholder keys
- **MLA Posts feed**: Display MLA posts list and detail on home/updates; support liking posts
- **Public Events feed**: Display upcoming and full events list with detail view and show-interest action
- **Notifications UI**: Full notification center screen with mark-as-read, grouped by type, deeplink routing
- **Delete Account**: Account deletion flow from profile settings with confirmation dialog
- **Comments**: View and post comments on concerns, ideas, and appreciations (public board + own submissions)
- **Conversations / Chat**: Create threads with MLA office, list threads, send/receive messages, close thread
- **Visibility controls**: UI to change visibility (public/private/anonymous) on own submissions
- **Delete submission UI**: Confirmation flow for deleting own concerns, ideas, appreciations
- **Ward cool-off enforcement**: Block ward change if last changed within 1 year, show days remaining
- **Daily concern limit**: Block concern submission after 2 concerns in rolling 24h window, show reset time
- **Leaderboard & Badges**: Citizen ranking by contribution count and badge display on profile

## Capabilities

### New Capabilities

- `app-config`: Remote app configuration fetched at startup and cached locally
- `media-upload`: Presigned S3 URL upload flow for submission attachments
- `mla-posts`: MLA posts feed, detail view, and like action
- `public-events`: Public events feed, detail view, and show-interest action
- `notifications-ui`: Notification center with mark-as-read and type-based routing
- `delete-account`: Account deletion with confirmation and session teardown
- `comments`: Comment listing, creation, and deletion on concerns/ideas/appreciations
- `conversations`: Chat threads between citizen and MLA office
- `submission-controls`: Visibility change and delete confirmation for own submissions
- `governance-limits`: Ward cool-off period and daily concern submission cap
- `leaderboard-badges`: Citizen leaderboard ranking and badge display

### Modified Capabilities

- `onboarding`: Ward selection now checks cool-off before allowing change (new business rule on existing flow)

## Impact

- **lib/data/remote/**: New Retrofit methods on existing API files + `config_api.dart` integration
- **lib/data/services/**: Updates to all submission services for presigned URL flow; new `config_service.dart`
- **lib/features/**: New screens for notifications, chat (already has shell), posts, events detail, leaderboard; updates to profile, report, concern/idea/appreciation detail views
- **lib/data/models/**: Models for posts, events, comments, conversation messages already exist — wire them up
- **Dependencies**: No new packages needed (image_picker, dio, cached_network_image already present)
