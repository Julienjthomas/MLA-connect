## Why

`OfficeMessagesService` queries Supabase directly. New backend exposes `/conversations/threads` endpoints for citizen-MLA messaging.

## What Changes

- Create `ConversationThread` and `ConversationMessage` freezed models
- Create `ConversationsApi` retrofit client — create thread, list threads, get thread, send message, close thread
- Rewrite `OfficeMessagesService` to use `ConversationsApi`

## Capabilities

### New Capabilities
- `rest-conversations`: Citizen-MLA conversation threads via REST

### Modified Capabilities
- `mla-office-chat`: Chat backed by REST conversations API

## Impact
- `lib/data/models/conversation/` — new freezed models
- `lib/data/remote/conversations_api.dart` — new retrofit client
- `lib/data/services/office_messages_service.dart` — rewrite
