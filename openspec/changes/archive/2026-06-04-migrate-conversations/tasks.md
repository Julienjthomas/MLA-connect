## 1. Models

- [x] 1.1 Create `lib/data/models/conversation/conversation_thread.dart` — freezed: `{id, citizenId, constituencyId, status, createdAt, lastMessageAt?}`
- [x] 1.2 Create `lib/data/models/conversation/conversation_message.dart` — freezed: `{id, threadId, senderType, body, createdAt}`
- [x] 1.3 Create `lib/data/models/conversation/send_message_request.dart` — freezed: `{body}`
- [x] 1.4 Run `dart run build_runner build`

## 2. API Client

- [x] 2.1 Create `lib/data/remote/conversations_api.dart` — retrofit:
  - `POST /citizens/:citizenId/conversations/threads`
  - `GET /citizens/:citizenId/conversations/threads`
  - `GET /citizens/:citizenId/conversations/threads/{threadId}`
  - `POST /citizens/:citizenId/conversations/threads/{threadId}/messages`
  - `POST /citizens/:citizenId/conversations/threads/{threadId}/close`
- [x] 2.2 Run `dart run build_runner build`
- [x] 2.3 Register `ConversationsApi` in DI in all 3 entry points

## 3. Rewrite Service

- [x] 3.1 Rewrite `lib/data/services/office_messages_service.dart` — use `ConversationsApi`, map to `OfficeMessageModel`
- [x] 3.2 Remove supabase imports

## 4. Verify

- [x] 4.1 Run `flutter analyze` — no errors
- [x] 4.2 Run app — chat/messages load [manual]
