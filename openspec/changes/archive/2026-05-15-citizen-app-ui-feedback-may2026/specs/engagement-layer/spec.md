## MODIFIED Requirements

### Requirement: Like action inserts to likes table
`UpdatesService.likeUpdate` SHALL insert a row into `likes` with the current citizen user id, `target_type` aligned with the live posts feed (`post` when posts are the source table), and `target_id` set to the update id. It SHALL use upsert with `onConflict` so repeat likes are idempotent.

#### Scenario: Like an update
- **WHEN** `likeUpdate(id)` is called for a signed-in user
- **THEN** a row is upserted to `likes` with the canonical `target_type` and `target_id=id`
- **THEN** calling again with the same id does not produce an error

### Requirement: Unlike action deletes from likes table
`UpdatesService` SHALL expose an `unlikeUpdate(String id)` method that deletes the row from `likes` matching current user, canonical `target_type`, and `target_id=id`.

#### Scenario: Unlike an update
- **WHEN** `unlikeUpdate(id)` is called for a signed-in user
- **THEN** the matching row is deleted from the `likes` table

## ADDED Requirements

### Requirement: Hydrate user likes for posts feed
When loading updates for a signed-in user, the client SHALL query which post ids the user has liked and SHALL initialize UI liked state before or immediately after rendering the feed.

#### Scenario: Feed shows prior likes
- **WHEN** a signed-in user opens the Updates feed and has previously liked a post
- **THEN** that post's like control renders in the liked state without requiring a new tap
