# MLA Connect — Backend API Contract

> Source: MLAConnect - Pitch.docx (extracted 2026-06-03)

## Config

- `GET /app-config` — Get App Config

## Auth

- `POST /auth/otp/send` — Request OTP
- `POST /auth/otp/verify` — Verify OTP → `{token: string, isNewUser: boolean}`
- `POST /citizens/:citizenId/auth/logout` — Logout
- `POST /citizens/:citizenId/auth/refresh` — Refresh Token
- `DELETE /citizens/:citizenId/account` — Delete Account

## Citizen Basic Info (Onboarding)

- `POST /citizens/:citizenId/basic-info/profile-pic/presigned-url` — Get presigned URL for S3 upload
- `POST /citizens/:citizenId/basic-info/profile-pic` — Update profile pic after S3 upload
- `POST /citizens/:citizenId/basic-info/personal-info` — Update personal info

## Citizen Profile & Settings

- `GET /citizens/:citizenId/profile` — Get Citizen Profile
- `POST /citizens/:citizenId/profile/update` — Update Profile
- `POST /citizens/:citizenId/profile/update-profile-pic` — Update Profile Picture
- `POST /citizens/:citizenId/profile/update-personal-info` — Update Personal Info
- `GET /citizens/:citizenId/settings` — Get Citizen Settings
- `PUT /citizens/:citizenId/settings` — Update Citizen Settings

## Notifications

- `GET /citizens/:citizenId/notifications` — Get Notifications
- `POST /citizens/:citizenId/notifications/mark-as-read` — Mark as Read

## Activity

- `GET /citizens/:citizenId/activity/summary` — Get Activity Summary

## Concerns (Citizen-scoped)

- `POST /citizens/:citizenId/concerns` — Create Concern
- `GET /citizens/:citizenId/concerns` — Get My Concerns
- `GET /citizens/:citizenId/concerns/:concernId` — Get Concern
- `DELETE /citizens/:citizenId/concerns/:concernId` — Delete Concern
- Presigned URL endpoint for media

## Concerns (Constituency-scoped / Public Board)

- `GET /constituencies/:constituencyId/concerns` — Get Constituency Concerns
- `GET /constituencies/:constituencyId/concerns/:concernId` — Get Concern
- `POST /constituencies/:constituencyId/concerns/:concernId/like` — Like
- `GET /constituencies/:constituencyId/concerns/:concernId/comments` — Get Comments
- `POST /constituencies/:constituencyId/concerns/:concernId/comments` — Add Comment
- `DELETE /constituencies/:constituencyId/concerns/:concernId/comments/:commentId` — Delete Comment

## Ideas (Citizen-scoped)

- `POST /citizens/:citizenId/ideas` — Create Idea
- `GET /citizens/:citizenId/ideas` — Get My Ideas
- `GET /citizens/:citizenId/ideas/:ideaId` — Get Idea
- `DELETE /citizens/:citizenId/ideas/:ideaId` — Delete Idea
- Presigned URL endpoint for media

## Ideas (Constituency-scoped / Public Board)

- `GET /constituencies/:constituencyId/ideas` — Get Constituency Ideas
- `GET /constituencies/:constituencyId/ideas/:ideaId` — Get Idea
- `POST /constituencies/:constituencyId/ideas/:ideaId/upvote` — Upvote
- `POST /constituencies/:constituencyId/ideas/:ideaId/downvote` — Downvote
- `POST /constituencies/:constituencyId/ideas/:ideaId/comments` — Add Comment
- `GET /constituencies/:constituencyId/ideas/:ideaId/comments` — Get Comments
- `DELETE /constituencies/:constituencyId/ideas/:ideaId/comments/:commentId` — Delete Comment

## Appreciations (Citizen-scoped)

- `POST /citizens/:citizenId/appreciations` — Create Appreciation
- `GET /citizens/:citizenId/appreciations` — Get My Appreciations
- `GET /citizens/:citizenId/appreciations/:appreciationId` — Get Appreciation
- `DELETE /citizens/:citizenId/appreciations/:appreciationId` — Delete Appreciation
- Presigned URL endpoint for media

## Appreciations (Constituency-scoped / Public Board)

- `GET /constituencies/:constituencyId/appreciations` — Get Constituency Appreciations
- `GET /constituencies/:constituencyId/appreciations/:appreciationId` — Get Appreciation
- `POST /constituencies/:constituencyId/appreciations/:appreciationId/like` — Like
- `GET /constituencies/:constituencyId/appreciations/:appreciationId/comments` — Get Comments
- `POST /constituencies/:constituencyId/appreciations/:appreciationId/comments` — Add Comment
- `DELETE /constituencies/:constituencyId/appreciations/:appreciationId/comments/:commentId` — Delete Comment

## MLA & Constituency

- `GET /constituencies/:constituencyId/mla` — Get MLA
- `GET /constituencies/:constituencyId/summary` — Get Summary
- `GET /constituencies/posts/recent` — Get Recent Posts
- `GET /constituencies/appreciations/trending` — Get Trending Appreciations
- `GET /constituencies/ideas/top` — Get Top Ideas
- `GET /constituencies/public-events/upcoming` — Get Upcoming Events

## MLA Posts

- `GET /constituencies/:constituencyId/posts` — Get MLA Posts
- `GET /constituencies/:constituencyId/posts/:postId` — Get Post
- `POST /constituencies/:constituencyId/posts/:postId/like` — Like Post

## Public Events

- `GET /constituencies/:constituencyId/public-events` — Get Events
- `GET /constituencies/:constituencyId/public-events/:publicEventId` — Get Event
- `POST /constituencies/:constituencyId/public-events/:publicEventId/show-interest` — Show Interest

## Conversations

- `POST /citizens/:citizenId/conversations/threads` — Create Thread
- `GET /citizens/:citizenId/conversations/threads` — Get All Threads
- `GET /citizens/:citizenId/conversations/threads/:threadId` — Get Thread
- `POST /citizens/:citizenId/conversations/threads/:threadId/messages` — Send Message
- `POST /citizens/:citizenId/conversations/threads/:threadId/close` — Close Thread

## Geography (Optional)

- `GET /constituencies` — Get Constituencies
- `GET /constituencies/:constituencyId/local-bodies` — Get Local Bodies
- `GET /constituencies/:constituencyId/local-bodies/:localBodyId/wards` — Get Wards
