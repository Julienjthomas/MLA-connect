-- =====================================================================
-- SUPER BALUSSERY — SUPABASE SCHEMA (Citizen + Staff app shared DB)
-- =====================================================================
-- Two apps share this Postgres:
--   1. Citizen app  → users in `citizens`, role-bound by RLS
--   2. Staff app    → users in `mla_staff`, role-bound by RLS
-- Both authenticate against auth.users; a user belongs to exactly one
-- of the two tables (enforced at signup).
--
-- Entity tables use internal bigint `id` (identity PK) plus stable
-- external `public_id` (uuid, gen_random_uuid()) for APIs and sharing.
-- `citizens.user_id` / `mla_staff.user_id` reference auth.users and
-- power RLS via auth.uid().
-- =====================================================================
-- This file is a faithful snapshot of the live database (regenerated
-- from pg_catalog). Applying it to a clean Postgres reproduces the
-- live shape exactly. Notes on intentional non-changes:
--   - `submission_status_history` has RLS **DISABLED** in live (the
--     CREATE POLICY statements below still exist but are not enforced).
--     Treat this as a known security gap; enable RLS only after the
--     reporter-app paths have been verified end-to-end.
--   - The app code references a few objects that are NOT in live and
--     therefore NOT in this file: `office_messages` table, the
--     `constituencies.slug` column, and the `v_my_activity_counts` /
--     `v_mla_stats` / `v_unread_notifications` views. Those features
--     fail soft in the app (try/catch → empty result). Add them via
--     a forward migration when those features ship.
-- =====================================================================
-- Creation order (forward references resolved):
--   1. Geography      → constituencies, local_bodies, wards
--   2. MLA            → mlas
--   3. Citizens       → citizens
--   4. Staff          → mla_staff
--   5. Projects       → projects                (needs mlas, mla_staff)
--   6. Events         → events, event_rsvps     (needs mla_staff, citizens)
--   7. Submissions    → submissions, history    (needs citizens, mla_staff)
--   8. Posts          → posts                   (needs submissions, events, projects)
--   9. Engagement     → media, likes, saves, shares, comments
--  10. Achievements   → achievement_categories, achievers
--  11. Notifications  → preferences, notifications
--  12. Support        → faqs, contact_messages
--  13. Audit / extras → audit_log, banners, flags, drafts, search, config
--  14. RLS policies
-- =====================================================================


-- =====================================================================
-- 1. GEOGRAPHY
-- =====================================================================

-- A constituency is the MLA's electoral area. Currently single-tenant
-- (Balussery), but modeled as a table so the system extends cleanly.
create table constituencies (
  id          bigint primary key generated always as identity,
  public_id   uuid not null default gen_random_uuid() unique,
  name        text not null,                           -- "Balussery"
  state       text not null default 'Kerala',
  is_active   boolean not null default true,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);


-- Local self-government bodies. `type` is text instead of enum so the
-- list (panchayat | municipality | corporation) can evolve without
-- migrations. App-layer validates.
create table local_bodies (
  id              bigint primary key generated always as identity,
  public_id       uuid not null default gen_random_uuid() unique,
  constituency_id bigint not null references constituencies(id) on delete restrict,
  name            text not null,                       -- "Chemancheri, Atholi"
  type            text not null,                       -- 'panchayat'|'municipality'|'corporation'
  is_active       boolean not null default true,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);

create index idx_local_bodies_constituency on local_bodies(constituency_id);


-- Wards belong to a local body. ward_number is the official numbering
-- shown in the UI ("Ward 12 - Kuttikattoor").
create table wards (
  id            bigint primary key generated always as identity,
  public_id     uuid not null default gen_random_uuid() unique,
  local_body_id bigint not null references local_bodies(id) on delete cascade,
  ward_number   int  not null,
  name          text not null,                         -- "Ward - 1 Kappad North"
  is_active     boolean not null default true,
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now()
);

create index idx_wards_local_body on wards(local_body_id);


-- =====================================================================
-- 2. MLA (the elected representative — read-only on citizen app)
-- =====================================================================

-- The MLA is not a logged-in user of either app at the row level; staff
-- post on the MLA's behalf. This table holds public-facing MLA info
-- shown on Home (avatar + name) and the MLA Detail Page (bio, term, stats).
create table mlas (
  id              bigint primary key generated always as identity,
  public_id       uuid not null default gen_random_uuid() unique,
  constituency_id bigint not null references constituencies(id) on delete restrict,
  full_name       text not null,                       -- "V T Sooraj"
  photo_url       text,
  cover_image_url text,
  term_label      text,                                -- "3rd Term MLA"
  serving_since   date,                                -- "Since 2016"
  bio             text,                                -- About MLA paragraph
  office_phone    text,
  office_email    text,
  office_address  text,
  is_current      boolean not null default true,       -- only one current MLA per constituency
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);

create index idx_mlas_constituency on mlas(constituency_id) where is_current;


-- =====================================================================
-- 3. CITIZENS
-- =====================================================================

-- 1:1 with auth.users for citizens only. Staff have their own table.
create table citizens (
  id              bigint primary key generated always as identity,
  public_id       uuid not null default gen_random_uuid() unique,
  user_id         uuid not null unique references auth.users(id) on delete cascade,
  full_name       text not null,
  email           text,
  phone           text not null,                       -- mirrored from auth.users
  avatar_url      text,
  language        text not null default 'en',          -- 'en' | 'ml'
  local_body_id   bigint references local_bodies(id) on delete set null,
  ward_id         bigint references wards(id) on delete set null,
  constituency_id bigint references constituencies(id) on delete set null, -- assembly (multi-constituency)
  onboarded_at    timestamptz,                         -- null = onboarding incomplete
  -- Soft delete so engagement (likes/comments) stays referentially safe
  deleted_at      timestamptz,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);

create index idx_citizens_ward       on citizens(ward_id);
create index idx_citizens_local_body on citizens(local_body_id);
create index idx_citizens_constituency on citizens(constituency_id);


-- =====================================================================
-- 4. MLA STAFF (login table for the staff app)
-- =====================================================================

-- 1:1 with auth.users for staff. A user is in `citizens` OR `mla_staff`,
-- never both — enforced by the signup flow in each app.
create table mla_staff (
  id              bigint primary key generated always as identity,
  public_id       uuid not null default gen_random_uuid() unique,
  user_id         uuid not null unique references auth.users(id) on delete cascade,
  mla_id          bigint references mlas(id) on delete set null,

  full_name       text not null,
  designation     text,                                -- "Personal Assistant", "Coordinator"
  role            text not null default 'staff',       -- 'mla'|'staff'|'admin'
  photo_url       text,

  -- Contact details (also surfaced on citizen app when is_public = true)
  phone           text not null,
  email           text,
  office_address  text,

  -- Optional scope: a staff member may handle a specific local body
  local_body_id   bigint references local_bodies(id) on delete set null,

  -- Visibility & state
  is_public       boolean not null default true,       -- show on Contact MLA Office screen
  position        int not null default 0,              -- ordering on Contact screen
  is_active       boolean not null default true,       -- soft-disable login

  last_login_at   timestamptz,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);

create index idx_mla_staff_mla        on mla_staff(mla_id);
create index idx_mla_staff_local_body on mla_staff(local_body_id);
create index idx_mla_staff_role       on mla_staff(role);
create index idx_mla_staff_public     on mla_staff(is_public, position) where is_public and is_active;


-- =====================================================================
-- 5. PROJECTS (MLA development projects)
-- =====================================================================

-- The MLA Detail Page shows "86 Active Projects" and the Posts feed
-- has a 'development' category showing project work. Projects are a
-- first-class entity so a single project can have multiple posts,
-- a budget, a timeline, and a status.
create table projects (
  id              bigint primary key generated always as identity,
  public_id       uuid not null default gen_random_uuid() unique,
  mla_id          bigint references mlas(id) on delete set null,
  title           text not null,                       -- "Road overlay at Kuttikattoor"
  description     text,
  category        text,                                -- "Roads", "Water", "Education"
  status          text not null default 'planned',     -- 'planned'|'active'|'on_hold'|'completed'|'cancelled'
  budget          numeric(14,2),
  budget_currency text default 'INR',
  started_at      date,
  completed_at    date,
  local_body_id   bigint references local_bodies(id),
  ward_id         bigint references wards(id),
  cover_image_url text,
  created_by      bigint references mla_staff(id) on delete set null,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);

create index idx_projects_mla        on projects(mla_id);
create index idx_projects_status     on projects(status);
create index idx_projects_ward       on projects(ward_id);
create index idx_projects_local_body on projects(local_body_id);


-- =====================================================================
-- 6. EVENTS (Public Grievance Hearing card on Home, etc.)
-- =====================================================================

create table events (
  id              bigint primary key generated always as identity,
  public_id       uuid not null default gen_random_uuid() unique,
  title           text not null,                       -- "Public Grievance Hearing"
  description     text,
  kind            text not null default 'general',     -- 'grievance_hearing'|'public_meeting'
                                                       -- |'inauguration'|'visit'|'general'
  starts_at       timestamptz not null,
  ends_at         timestamptz,
  venue_name      text,                                -- "Town Hall, Balussery"
  venue_address   text,
  local_body_id   bigint references local_bodies(id),
  ward_id         bigint references wards(id),
  cover_image_url text,
  created_by      bigint references mla_staff(id) on delete set null,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);

create index idx_events_starts on events(starts_at);


-- "View Details" / RSVP engagement
create table event_rsvps (
  event_id    bigint not null references events(id) on delete cascade,
  user_id     bigint not null references citizens(id) on delete cascade,
  status      text not null default 'interested',      -- 'interested'|'going'|'not_going'
  created_at  timestamptz not null default now(),
  primary key (event_id, user_id)
);


-- =====================================================================
-- 7. SUBMISSIONS (Reports, Appreciations, Ideas, Suggestions)
-- =====================================================================

-- Unified table for all four citizen-initiated content types. `kind`
-- discriminates. Many columns are NULL for any given row; that's
-- expected — app validates per-kind which fields are required.
create table submissions (
  id                bigint primary key generated always as identity,
  public_id         uuid not null default gen_random_uuid() unique,
  reference_id      text not null unique,              -- "RP2024001256", "AP...", "ID...", "SG..."
  kind              text not null,                     -- 'report'|'appreciation'|'idea'|'suggestion'
  reporter_id       bigint not null references citizens(id) on delete restrict,

  -- Common: Details (all kinds)
  title             text not null,
  description       text not null,
  category          text,                              -- "Roads & Infrastructure / Pothole", "Environmental"
  topic             text,                              -- ideas: "Environmental"
  voice_message_url text,                              -- reports: voice attachment from Step 1

  -- Common: Location (primarily reports; optional for others)
  local_body_id     bigint references local_bodies(id),
  ward_id           bigint references wards(id),
  landmark          text,
  pin_latitude      numeric(9,6),
  pin_longitude     numeric(9,6),
  pin_address       text,                              -- reverse-geocoded

  -- Common: Contact (defaults from citizen record, can override per submission)
  contact_phone     text,

  -- Appreciation-specific (Step 1 of Appreciate flow)
  target_type           text,                          -- 'government_staff'|'mla'|'department'|'project'
  recipient_staff_name  text,                          -- "Ajith Kumar, AE"
  recipient_department  text,                          -- "Public Works Department"
  related_project_name  text,                          -- "Road repair at Kuttikattoor"

  -- Idea-specific (Step 2 of Share Idea flow: Impact)
  benefits                text,
  beneficiaries           text[] not null default '{}',  -- 'residents','businesses','students'...
  estimated_cost_min      numeric(14,2),
  estimated_cost_max      numeric(14,2),
  estimated_cost_currency text default 'INR',

  -- Visibility (ideas + appreciations: Step 3 of those flows)
  visibility                  text,                    -- 'public'|'mla_office_only'|'anonymous'|'private_mla_only'
  is_anonymous                boolean not null default false,
  allow_community_discussion  boolean,
  allow_mla_office_contact    boolean,

  -- Workflow (reports + ideas)
  status              text not null default 'submitted',
                                                       -- 'submitted'|'under_review'|'assigned'|'in_progress'
                                                       -- 'resolved'|'rejected'|'closed'
                                                       -- 'approved'|'implementing'|'implemented'  (ideas)
  assigned_department text,                            -- "Public Works Department"
  assigned_staff_id   bigint references mla_staff(id) on delete set null,  -- staff handling this
  resolved_at         timestamptz,
  resolution_notes    text,

  -- Engagement counters (denormalized; kept in sync via triggers)
  view_count        int not null default 0,
  like_count        int not null default 0,
  share_count       int not null default 0,
  comment_count     int not null default 0,

  -- Soft delete (keeps engagement rows valid)
  deleted_at        timestamptz,

  created_at        timestamptz not null default now(),
  updated_at        timestamptz not null default now()
);

create index idx_submissions_reporter   on submissions(reporter_id);
create index idx_submissions_kind       on submissions(kind, created_at desc);
create index idx_submissions_status     on submissions(kind, status);
create index idx_submissions_ward       on submissions(ward_id);
create index idx_submissions_local_body on submissions(local_body_id);
create index idx_submissions_category   on submissions(category);
create index idx_submissions_assigned   on submissions(assigned_staff_id) where assigned_staff_id is not null;


-- Status timeline. Every status change appends a row. Drives the
-- "Under Review → Assigned → In Progress → Resolved" timeline shown
-- on a submission's detail page.
create table submission_status_history (
  id            bigint primary key generated always as identity,
  public_id     uuid not null default gen_random_uuid() unique,
  submission_id bigint not null references submissions(id) on delete cascade,
  from_status   text,
  to_status     text not null,
  changed_by    bigint references mla_staff(id) on delete set null,
  notes         text,
  created_at    timestamptz not null default now()
);

create index idx_status_history_submission on submission_status_history(submission_id, created_at desc);


-- =====================================================================
-- 8. POSTS (MLA-posted feed: announcements, work updates, alerts)
-- =====================================================================

-- All FK targets (submissions, events, projects, mla_staff) now exist.
create table posts (
  id              bigint primary key generated always as identity,
  public_id       uuid not null default gen_random_uuid() unique,

  -- Authorship
  author_id       bigint references mla_staff(id) on delete set null,
  author_name     text,                                -- denormalized snapshot, e.g. "MLA Office"

  title           text not null,
  body            text,
  cover_image_url text,

  -- Categorization
  category        text not null,                       -- 'announcement'|'development'|'work_update'|'alert'
                                                       -- 'emergency'|'event'|'achievement'|'resolved'
                                                       -- 'education'|'water'|'health'|'general'
  tags            text[] not null default '{}',
  priority        text not null default 'normal',      -- 'normal'|'important'|'urgent'

  -- Optional context links
  related_submission_id bigint references submissions(id) on delete set null,
  related_event_id      bigint references events(id) on delete set null,
  project_id            bigint references projects(id) on delete set null,

  -- Scope (null = constituency-wide)
  local_body_id   bigint references local_bodies(id),
  ward_id         bigint references wards(id),

  -- Lifecycle
  is_pinned       boolean not null default false,
  published_at    timestamptz not null default now(),
  expires_at      timestamptz,                         -- alerts auto-hide
  deleted_at      timestamptz,

  -- Engagement counters
  view_count      int not null default 0,
  like_count      int not null default 0,
  share_count     int not null default 0,
  comment_count   int not null default 0,

  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);

create index idx_posts_category   on posts(category);
create index idx_posts_published  on posts(published_at desc);
create index idx_posts_ward       on posts(ward_id);
create index idx_posts_local_body on posts(local_body_id);
create index idx_posts_project    on posts(project_id);
create index idx_posts_pinned     on posts(is_pinned, published_at desc) where is_pinned;
create index idx_posts_priority   on posts(priority, published_at desc) where priority <> 'normal';


-- =====================================================================
-- 9. POLYMORPHIC MEDIA & ENGAGEMENT
-- =====================================================================

-- Media attachments work for submissions, posts, and events.
-- attachable_type validated in app. attachable_id references internal bigint ids.
create table media_attachments (
  id               bigint primary key generated always as identity,
  public_id        uuid not null default gen_random_uuid() unique,
  attachable_type  text not null,                      -- 'submission'|'post'|'event'
  attachable_id    bigint not null,
  kind             text not null,                      -- 'image'|'video'|'audio'|'document'
  storage_path     text not null,                      -- supabase storage path
  url              text,                               -- cached public URL
  position         int not null default 0,             -- ordering
  caption          text,
  size_bytes       bigint,
  mime_type        text,
  duration_seconds int,                                -- for audio/video
  -- Who uploaded this file: a `citizens` row or `mla_staff` (see uploaded_by_type).
  uploaded_by      bigint,
  uploaded_by_type text check (uploaded_by_type in ('citizen','mla_staff')),
  created_at       timestamptz not null default now()
);

create index idx_media_attachable on media_attachments(attachable_type, attachable_id);


-- Likes — unique per (citizen, target).
create table likes (
  user_id      bigint not null references citizens(id) on delete cascade,
  target_type  text not null,                          -- 'submission'|'post'
  target_id    bigint not null,
  created_at   timestamptz not null default now(),
  primary key (user_id, target_type, target_id)
);

create index idx_likes_target on likes(target_type, target_id);


-- Saves (the bookmark icon on Posts feed).
create table saves (
  user_id      bigint not null references citizens(id) on delete cascade,
  target_type  text not null,
  target_id    bigint not null,
  created_at   timestamptz not null default now(),
  primary key (user_id, target_type, target_id)
);

create index idx_saves_user on saves(user_id, created_at desc);


-- Shares (logged per share event so a user can share to multiple channels).
create table shares (
  id           bigint primary key generated always as identity,
  public_id    uuid not null default gen_random_uuid() unique,
  user_id      bigint references citizens(id) on delete set null,
  target_type  text not null,
  target_id    bigint not null,
  channel      text,                                   -- 'whatsapp'|'copy_link'|...
  created_at   timestamptz not null default now()
);

create index idx_shares_target on shares(target_type, target_id);


-- Comments with threading via parent_id self-reference.
create table comments (
  id           bigint primary key generated always as identity,
  public_id    uuid not null default gen_random_uuid() unique,
  author_id    bigint not null references citizens(id) on delete cascade,
  target_type  text not null,
  target_id    bigint not null,
  parent_id    bigint references comments(id) on delete cascade,
  body         text not null,
  is_deleted   boolean not null default false,
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now()
);

create index idx_comments_target on comments(target_type, target_id, created_at desc);
create index idx_comments_parent on comments(parent_id);


-- =====================================================================
-- 10. HALL OF EXCELLENCE (achievements carousel on Home screen)
-- =====================================================================

create table achievement_categories (
  id          bigint primary key generated always as identity,
  public_id   uuid not null default gen_random_uuid() unique,
  title       text not null,                           -- "SSLC FULL A+ ACHIEVERS 2024"
  subtitle    text,                                    -- "Hall of Excellence"
  year        int,
  is_active   boolean not null default true,
  position    int not null default 0,
  created_at  timestamptz not null default now()
);


create table achievers (
  id            bigint primary key generated always as identity,
  public_id     uuid not null default gen_random_uuid() unique,
  category_id   bigint not null references achievement_categories(id) on delete cascade,
  full_name     text not null,                         -- "Nandana P"
  institution   text,                                  -- "GVHSS Kodanchery"
  grade         text,                                  -- "A+"
  photo_url     text,
  ward_id       bigint references wards(id) on delete set null,
  position      int not null default 0,
  created_at    timestamptz not null default now()
);

create index idx_achievers_category on achievers(category_id, position);


-- =====================================================================
-- 11. NOTIFICATIONS
-- =====================================================================

-- One row per citizen, mirrors the toggles on Profile screen.
create table notification_preferences (
  id                  bigint primary key generated always as identity,
  public_id           uuid not null default gen_random_uuid() unique,
  user_id             bigint not null unique references citizens(id) on delete cascade,
  issue_updates       boolean not null default true,
  mla_announcements   boolean not null default true,
  event_reminders     boolean not null default true,
  emergency_alerts    boolean not null default false,
  push_token          text,                             -- FCM/APNs token
  push_platform       text,                             -- 'ios'|'android'|'web'
  updated_at          timestamptz not null default now()
);


-- Bell icon feed. is_read drives the "3" badge on Home header.
create table notifications (
  id          bigint primary key generated always as identity,
  public_id   uuid not null default gen_random_uuid() unique,
  user_id     bigint not null references citizens(id) on delete cascade,
  type        text not null,                           -- 'submission_status_changed'|'submission_resolved'
                                                       -- |'appreciation_received'|'new_post'
                                                       -- |'event_reminder'|'comment_reply'
                                                       -- |'mention'|'emergency_alert'
  channel     text not null,                           -- maps to a notification_preferences toggle
  title       text not null,
  body        text,
  -- deep-link payload
  target_type text,                                    -- 'submission'|'post'|'event'
  target_id   bigint,
  is_read     boolean not null default false,
  read_at     timestamptz,
  created_at  timestamptz not null default now()
);

create index idx_notif_user_unread on notifications(user_id, is_read, created_at desc);
create index idx_notif_user_recent on notifications(user_id, created_at desc);


-- =====================================================================
-- 12. SUPPORT (Help Center, Contact, FAQs)
-- =====================================================================

create table faqs (
  id          bigint primary key generated always as identity,
  public_id   uuid not null default gen_random_uuid() unique,
  question    text not null,
  answer      text not null,
  language    text not null default 'en',              -- 'en'|'ml'
  category    text,                                    -- "Account", "Reports", "Privacy"
  position    int not null default 0,
  is_active   boolean not null default true,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

create index idx_faqs_active on faqs(language, position) where is_active;


-- "Contact MLA Office" form / Help Center tickets
create table contact_messages (
  id          bigint primary key generated always as identity,
  public_id   uuid not null default gen_random_uuid() unique,
  user_id     bigint references citizens(id) on delete set null,
  subject     text not null,
  body        text not null,
  status      text not null default 'open',            -- 'open'|'in_progress'|'resolved'|'closed'
  handled_by  bigint references mla_staff(id) on delete set null,
  reply_body  text,
  replied_at  timestamptz,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

create index idx_contact_status on contact_messages(status, created_at desc);
create index idx_contact_user   on contact_messages(user_id, created_at desc);


-- =====================================================================
-- 13. AUDIT, BANNERS, FLAGS, DRAFTS, SEARCH, CONFIG
-- =====================================================================

-- ----- 13.1 AUDIT LOG ------------------------------------------------
-- Actor can be a citizen (`citizens`) OR a staff member (`mla_staff`).
-- We don't FK to either; both IDs come from auth.users so they share
-- the UUID space. App resolves which table when displaying.
create table audit_log (
  id           bigint primary key generated always as identity,
  public_id    uuid not null default gen_random_uuid() unique,
  actor_id     uuid,
  actor_type   text,                                   -- 'citizen'|'staff'
  action       text not null,                          -- 'submission.status_change', 'idea.approve'
  target_type  text,
  target_id    bigint,
  metadata     jsonb,
  created_at   timestamptz not null default now()
);

create index idx_audit_target on audit_log(target_type, target_id, created_at desc);
create index idx_audit_actor  on audit_log(actor_id, created_at desc);


-- ----- 13.2 BANNERS / EMERGENCY ALERTS -------------------------------
-- For announcements that aren't full feed posts — e.g. a maintenance
-- notice, time-bound advisory. Posts with priority='urgent' could
-- also be promoted to banners by the app.
create table banners (
  id              bigint primary key generated always as identity,
  public_id       uuid not null default gen_random_uuid() unique,
  title           text not null,
  body            text,
  priority        text not null default 'info',        -- 'info'|'warning'|'urgent'
  action_label    text,                                -- "View Details"
  action_url      text,                                -- deep link
  -- Targeting (null = constituency-wide)
  local_body_id   bigint references local_bodies(id),
  ward_id         bigint references wards(id),
  -- Lifecycle
  starts_at       timestamptz not null default now(),
  ends_at         timestamptz,
  is_active       boolean not null default true,
  created_by      bigint references mla_staff(id) on delete set null,
  created_at      timestamptz not null default now()
);

create index idx_banners_active on banners(is_active, starts_at, ends_at);


-- ----- 13.3 CONTENT MODERATION ---------------------------------------
-- Citizens flag inappropriate comments/submissions/posts; staff
-- review and action.
create table content_flags (
  id            bigint primary key generated always as identity,
  public_id     uuid not null default gen_random_uuid() unique,
  flagger_id    bigint not null references citizens(id) on delete cascade,
  target_type   text not null,                         -- 'comment'|'submission'|'post'
  target_id     bigint not null,
  reason        text not null,                         -- 'spam'|'abuse'|'misinfo'|'other'
  details       text,
  status        text not null default 'pending',       -- 'pending'|'reviewed'|'dismissed'|'actioned'
  reviewed_by   bigint references mla_staff(id) on delete set null,
  reviewed_at   timestamptz,
  created_at    timestamptz not null default now()
);

create index idx_flags_status on content_flags(status, created_at desc);
create index idx_flags_target on content_flags(target_type, target_id);


-- ----- 13.4 SUBMISSION DRAFTS ----------------------------------------
-- The 4-step Report/Appreciate/Idea flows are easy to abandon. Persist
-- partial form state so users can resume later.
create table submission_drafts (
  id            bigint primary key generated always as identity,
  public_id     uuid not null default gen_random_uuid() unique,
  user_id       bigint not null references citizens(id) on delete cascade,
  kind          text not null,                         -- 'report'|'appreciation'|'idea'|'suggestion'
  step          int not null default 1,                -- last completed step
  data          jsonb not null default '{}',           -- partial form state
  expires_at    timestamptz not null default (now() + interval '30 days'),
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now()
);

create index idx_drafts_user on submission_drafts(user_id, updated_at desc);


-- ----- 13.5 SEARCH ANALYTICS -----------------------------------------
-- The Posts screen has a search icon. Logging queries lets us see
-- trending topics and tune category lists.
create table search_queries (
  id           bigint primary key generated always as identity,
  public_id    uuid not null default gen_random_uuid() unique,
  user_id      bigint references citizens(id) on delete set null,
  query        text not null,
  result_count int,
  created_at   timestamptz not null default now()
);

create index idx_search_recent on search_queries(created_at desc);


-- ----- 13.6 APP CONFIG / FEATURE FLAGS -------------------------------
-- Toggle features without deploying. Examples: enable/disable comments,
-- canonical category lists, Hall of Excellence visibility per season.
create table app_config (
  id          bigint primary key generated always as identity,
  public_id   uuid not null default gen_random_uuid() unique,
  key         text not null unique,
  value       jsonb not null,
  description text,
  updated_by  bigint references mla_staff(id) on delete set null,
  updated_at  timestamptz not null default now()
);


-- =====================================================================
-- 14. ROW LEVEL SECURITY
-- =====================================================================
-- Helper functions so policies can cheaply check "is this user staff?".
-- security definer lets them bypass RLS on mla_staff itself.

create or replace function is_staff() returns boolean
language sql stable security definer
set search_path = public
as $$
  select exists (
    select 1 from mla_staff where user_id = auth.uid() and is_active
  );
$$;

-- Variant used by the staff portal. Treats NULL is_active as active so
-- newly-inserted staff rows (before the default flips on) still pass.
create or replace function is_mla_staff_active() returns boolean
language sql stable security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.mla_staff ms
    where ms.user_id = auth.uid()
      and coalesce(ms.is_active, true)
  );
$$;


-- ----- citizens -----
alter table citizens enable row level security;

create policy "read own citizen"
  on citizens for select
  using ( auth.uid() = user_id );

create policy "update own citizen"
  on citizens for update
  using ( auth.uid() = user_id )
  with check ( auth.uid() = user_id );

create policy "insert own citizen"
  on citizens for insert
  with check ( auth.uid() = user_id );

create policy "staff full access citizens"
  on citizens for all
  using ( is_staff() )
  with check ( is_staff() );


-- ----- geography & MLA directory (reference data) -----
alter table constituencies enable row level security;
alter table local_bodies enable row level security;
alter table wards enable row level security;
alter table mlas enable row level security;

create policy "authenticated read constituencies"
  on constituencies for select
  using ( auth.uid() is not null );

create policy "staff write constituencies"
  on constituencies for all
  using ( is_staff() )
  with check ( is_staff() );

create policy "authenticated read local_bodies"
  on local_bodies for select
  using ( auth.uid() is not null );

create policy "staff write local_bodies"
  on local_bodies for all
  using ( is_staff() )
  with check ( is_staff() );

create policy "authenticated read wards"
  on wards for select
  using ( auth.uid() is not null );

create policy "staff write wards"
  on wards for all
  using ( is_staff() )
  with check ( is_staff() );

create policy "authenticated read mlas"
  on mlas for select
  using ( auth.uid() is not null );

create policy "staff write mlas"
  on mlas for all
  using ( is_staff() )
  with check ( is_staff() );


-- ----- mla_staff -----
alter table mla_staff enable row level security;

create policy "read own staff row"
  on mla_staff for select
  using ( auth.uid() = user_id );

create policy "read public staff directory"
  on mla_staff for select
  using ( is_public and is_active );

create policy "read staff for colleagues"
  on mla_staff for select
  using ( is_staff() );

create policy "update own staff row"
  on mla_staff for update
  using ( auth.uid() = user_id )
  with check ( auth.uid() = user_id );

create policy "staff full access mla_staff"
  on mla_staff for all
  using ( is_staff() )
  with check ( is_staff() );


-- ----- projects & events -----
alter table projects enable row level security;
alter table events enable row level security;

create policy "authenticated read projects"
  on projects for select
  using ( auth.uid() is not null );

create policy "staff write projects"
  on projects for all
  using ( is_staff() )
  with check ( is_staff() );

create policy "authenticated read events"
  on events for select
  using ( auth.uid() is not null );

create policy "staff write events"
  on events for all
  using ( is_staff() )
  with check ( is_staff() );


-- ----- event_rsvps -----
alter table event_rsvps enable row level security;

create policy "read own rsvps"
  on event_rsvps for select
  using (
    auth.uid() = (select c.user_id from citizens c where c.id = event_rsvps.user_id)
  );

create policy "read rsvps staff"
  on event_rsvps for select
  using ( is_staff() );

create policy "manage own rsvps"
  on event_rsvps for insert
  with check (
    auth.uid() = (select c.user_id from citizens c where c.id = event_rsvps.user_id)
  );

create policy "update own rsvps"
  on event_rsvps for update
  using (
    auth.uid() = (select c.user_id from citizens c where c.id = event_rsvps.user_id)
  )
  with check (
    auth.uid() = (select c.user_id from citizens c where c.id = event_rsvps.user_id)
  );

create policy "delete own rsvps"
  on event_rsvps for delete
  using (
    auth.uid() = (select c.user_id from citizens c where c.id = event_rsvps.user_id)
  );

create policy "staff full access event_rsvps"
  on event_rsvps for all
  using ( is_staff() )
  with check ( is_staff() );


-- ----- submissions -----
alter table submissions enable row level security;

create policy "read submissions"
  on submissions for select
  using (
    auth.uid() is not null
    and (
      auth.uid() = (select c.user_id from citizens c where c.id = submissions.reporter_id)
      or (
        deleted_at is null
        and (
          visibility = 'public'
          or (kind = 'report' and is_anonymous = false)
        )
      )
    )
  );

create policy "create own submissions"
  on submissions for insert
  with check ( auth.uid() = (select c.user_id from citizens c where c.id = submissions.reporter_id) );

create policy "update own submissions"
  on submissions for update
  using ( auth.uid() = (select c.user_id from citizens c where c.id = submissions.reporter_id) )
  with check ( auth.uid() = (select c.user_id from citizens c where c.id = submissions.reporter_id) );

create policy "staff full access submissions"
  on submissions for all
  using ( is_staff() )
  with check ( is_staff() );


-- ----- submission_status_history -----
-- WARNING: RLS is currently DISABLED on this table in the live database.
-- The CREATE POLICY statements below are kept so that re-enabling RLS
-- becomes a single `alter table ... enable row level security;` change.
-- Until then, this table is exposed to anon/authenticated. Audit before
-- enabling — the timeline rows are linked to reporter identity.
-- alter table submission_status_history enable row level security;

create policy "read status history as reporter"
  on submission_status_history for select
  using (
    auth.uid() is not null
    and exists (
      select 1
      from submissions s
      where s.id = submission_status_history.submission_id
        and auth.uid() = (select c.user_id from citizens c where c.id = s.reporter_id)
    )
  );

create policy "read status history public submission"
  on submission_status_history for select
  using (
    auth.uid() is not null
    and exists (
      select 1
      from submissions s
      where s.id = submission_status_history.submission_id
        and s.deleted_at is null
        and (
          s.visibility = 'public'
          or (s.kind = 'report' and s.is_anonymous = false)
        )
    )
  );

create policy "staff full access submission_status_history"
  on submission_status_history for all
  using ( is_staff() )
  with check ( is_staff() );

create policy "portal staff submission_status_history"
  on submission_status_history for all
  to authenticated
  using ( is_mla_staff_active() )
  with check ( is_mla_staff_active() );


-- ----- posts -----
alter table posts enable row level security;

create policy "read posts"
  on posts for select
  using ( auth.uid() is not null and deleted_at is null );

create policy "staff write posts"
  on posts for all
  using ( is_staff() )
  with check ( is_staff() );


-- ----- media_attachments -----
alter table media_attachments enable row level security;

create policy "read media for post"
  on media_attachments for select
  using (
    auth.uid() is not null
    and attachable_type = 'post'
    and exists (
      select 1 from posts p
      where p.id = media_attachments.attachable_id and p.deleted_at is null
    )
  );

create policy "read media for event"
  on media_attachments for select
  using (
    auth.uid() is not null
    and attachable_type = 'event'
    and exists ( select 1 from events e where e.id = media_attachments.attachable_id )
  );

create policy "read media for submission"
  on media_attachments for select
  using (
    auth.uid() is not null
    and attachable_type = 'submission'
    and exists (
      select 1 from submissions s
      where s.id = media_attachments.attachable_id
        and (
          auth.uid() = (select c.user_id from citizens c where c.id = s.reporter_id)
          or (
            s.deleted_at is null
            and (
              s.visibility = 'public'
              or (s.kind = 'report' and s.is_anonymous = false)
            )
          )
        )
    )
  );

create policy "insert media citizen own upload"
  on media_attachments for insert
  with check (
    auth.uid() is not null
    and uploaded_by_type = 'citizen'
    and uploaded_by = (select c.id from citizens c where c.user_id = auth.uid())
  );

create policy "staff full access media_attachments"
  on media_attachments for all
  using ( is_staff() )
  with check ( is_staff() );


-- ----- likes -----
alter table likes enable row level security;

create policy "read likes authenticated"
  on likes for select
  using ( auth.uid() is not null );

create policy "insert own likes"
  on likes for insert
  with check (
    auth.uid() = (select c.user_id from citizens c where c.id = likes.user_id)
  );

create policy "delete own likes"
  on likes for delete
  using (
    auth.uid() = (select c.user_id from citizens c where c.id = likes.user_id)
  );

create policy "staff full access likes"
  on likes for all
  using ( is_staff() )
  with check ( is_staff() );


-- ----- saves -----
alter table saves enable row level security;

create policy "read own saves"
  on saves for select
  using (
    auth.uid() = (select c.user_id from citizens c where c.id = saves.user_id)
  );

create policy "manage own saves"
  on saves for insert
  with check (
    auth.uid() = (select c.user_id from citizens c where c.id = saves.user_id)
  );

create policy "delete own saves"
  on saves for delete
  using (
    auth.uid() = (select c.user_id from citizens c where c.id = saves.user_id)
  );

create policy "staff full access saves"
  on saves for all
  using ( is_staff() )
  with check ( is_staff() );


-- ----- shares -----
alter table shares enable row level security;

create policy "read own shares"
  on shares for select
  using (
    user_id is not null
    and auth.uid() = (select c.user_id from citizens c where c.id = shares.user_id)
  );

create policy "read shares staff"
  on shares for select
  using ( is_staff() );

create policy "insert shares"
  on shares for insert
  with check (
    user_id is null
    or auth.uid() = (select c.user_id from citizens c where c.id = shares.user_id)
  );

create policy "staff full access shares"
  on shares for all
  using ( is_staff() )
  with check ( is_staff() );


-- ----- comments -----
alter table comments enable row level security;

create policy "read comments on post"
  on comments for select
  using (
    auth.uid() is not null
    and target_type = 'post'
    and exists (
      select 1 from posts p
      where p.id = comments.target_id and p.deleted_at is null
    )
  );

create policy "read comments on event"
  on comments for select
  using (
    auth.uid() is not null
    and target_type = 'event'
    and exists ( select 1 from events e where e.id = comments.target_id )
  );

create policy "read comments on submission"
  on comments for select
  using (
    auth.uid() is not null
    and target_type = 'submission'
    and exists (
      select 1 from submissions s
      where s.id = comments.target_id
        and (
          auth.uid() = (select c.user_id from citizens c where c.id = s.reporter_id)
          or (
            s.deleted_at is null
            and (
              s.visibility = 'public'
              or (s.kind = 'report' and s.is_anonymous = false)
            )
          )
        )
    )
  );

create policy "insert own comments"
  on comments for insert
  with check (
    auth.uid() = (select c.user_id from citizens c where c.id = comments.author_id)
  );

create policy "update own comments"
  on comments for update
  using (
    auth.uid() = (select c.user_id from citizens c where c.id = comments.author_id)
  )
  with check (
    auth.uid() = (select c.user_id from citizens c where c.id = comments.author_id)
  );

create policy "delete own comments"
  on comments for delete
  using (
    auth.uid() = (select c.user_id from citizens c where c.id = comments.author_id)
  );

create policy "staff full access comments"
  on comments for all
  using ( is_staff() )
  with check ( is_staff() );


-- ----- achievements -----
alter table achievement_categories enable row level security;
alter table achievers enable row level security;

create policy "authenticated read achievement_categories"
  on achievement_categories for select
  using ( auth.uid() is not null and is_active );

create policy "staff write achievement_categories"
  on achievement_categories for all
  using ( is_staff() )
  with check ( is_staff() );

create policy "authenticated read achievers"
  on achievers for select
  using ( auth.uid() is not null );

create policy "staff write achievers"
  on achievers for all
  using ( is_staff() )
  with check ( is_staff() );


-- ----- notification_preferences -----
alter table notification_preferences enable row level security;

create policy "manage own notification_preferences"
  on notification_preferences for select
  using (
    auth.uid() = (select c.user_id from citizens c where c.id = notification_preferences.user_id)
  );

create policy "insert own notification_preferences"
  on notification_preferences for insert
  with check (
    auth.uid() = (select c.user_id from citizens c where c.id = notification_preferences.user_id)
  );

create policy "update own notification_preferences"
  on notification_preferences for update
  using (
    auth.uid() = (select c.user_id from citizens c where c.id = notification_preferences.user_id)
  )
  with check (
    auth.uid() = (select c.user_id from citizens c where c.id = notification_preferences.user_id)
  );

create policy "staff full access notification_preferences"
  on notification_preferences for all
  using ( is_staff() )
  with check ( is_staff() );


-- ----- notifications -----
alter table notifications enable row level security;

create policy "read own notifications"
  on notifications for select
  using (
    auth.uid() = (select c.user_id from citizens c where c.id = notifications.user_id)
  );

create policy "update own notifications"
  on notifications for update
  using (
    auth.uid() = (select c.user_id from citizens c where c.id = notifications.user_id)
  )
  with check (
    auth.uid() = (select c.user_id from citizens c where c.id = notifications.user_id)
  );

create policy "staff manage notifications"
  on notifications for all
  using ( is_staff() )
  with check ( is_staff() );


-- ----- faqs -----
alter table faqs enable row level security;

create policy "authenticated read active faqs"
  on faqs for select
  using ( auth.uid() is not null and is_active );

create policy "staff full access faqs"
  on faqs for all
  using ( is_staff() )
  with check ( is_staff() );


-- ----- contact_messages -----
alter table contact_messages enable row level security;

create policy "read own contact_messages"
  on contact_messages for select
  using (
    user_id is not null
    and auth.uid() = (select c.user_id from citizens c where c.id = contact_messages.user_id)
  );

create policy "read contact_messages staff"
  on contact_messages for select
  using ( is_staff() );

create policy "insert contact_messages"
  on contact_messages for insert
  with check (
    user_id is null
    or auth.uid() = (select c.user_id from citizens c where c.id = contact_messages.user_id)
  );

create policy "staff full access contact_messages"
  on contact_messages for all
  using ( is_staff() )
  with check ( is_staff() );


-- ----- audit_log -----
alter table audit_log enable row level security;

create policy "staff audit_log only"
  on audit_log for all
  using ( is_staff() )
  with check ( is_staff() );


-- ----- banners -----
alter table banners enable row level security;

create policy "authenticated read active banners"
  on banners for select
  using (
    auth.uid() is not null
    and is_active
    and starts_at <= now()
    and (ends_at is null or ends_at >= now())
  );

create policy "staff full access banners"
  on banners for all
  using ( is_staff() )
  with check ( is_staff() );


-- ----- content_flags -----
alter table content_flags enable row level security;

create policy "read own content_flags"
  on content_flags for select
  using (
    auth.uid() = (select c.user_id from citizens c where c.id = content_flags.flagger_id)
  );

create policy "read content_flags staff"
  on content_flags for select
  using ( is_staff() );

create policy "insert own content_flags"
  on content_flags for insert
  with check (
    auth.uid() = (select c.user_id from citizens c where c.id = content_flags.flagger_id)
  );

create policy "staff full access content_flags"
  on content_flags for all
  using ( is_staff() )
  with check ( is_staff() );


-- ----- submission_drafts -----
alter table submission_drafts enable row level security;

create policy "manage own submission_drafts"
  on submission_drafts for select
  using (
    auth.uid() = (select c.user_id from citizens c where c.id = submission_drafts.user_id)
  );

create policy "insert own submission_drafts"
  on submission_drafts for insert
  with check (
    auth.uid() = (select c.user_id from citizens c where c.id = submission_drafts.user_id)
  );

create policy "update own submission_drafts"
  on submission_drafts for update
  using (
    auth.uid() = (select c.user_id from citizens c where c.id = submission_drafts.user_id)
  )
  with check (
    auth.uid() = (select c.user_id from citizens c where c.id = submission_drafts.user_id)
  );

create policy "delete own submission_drafts"
  on submission_drafts for delete
  using (
    auth.uid() = (select c.user_id from citizens c where c.id = submission_drafts.user_id)
  );

create policy "staff full access submission_drafts"
  on submission_drafts for all
  using ( is_staff() )
  with check ( is_staff() );


-- ----- search_queries -----
alter table search_queries enable row level security;

create policy "insert own search_queries"
  on search_queries for insert
  with check (
    user_id is null
    or auth.uid() = (select c.user_id from citizens c where c.id = search_queries.user_id)
  );

create policy "read own search_queries"
  on search_queries for select
  using (
    user_id is not null
    and auth.uid() = (select c.user_id from citizens c where c.id = search_queries.user_id)
  );

create policy "read search_queries staff"
  on search_queries for select
  using ( is_staff() );

create policy "staff full access search_queries"
  on search_queries for all
  using ( is_staff() )
  with check ( is_staff() );


-- ----- app_config -----
alter table app_config enable row level security;

create policy "authenticated read app_config"
  on app_config for select
  using ( auth.uid() is not null );

create policy "staff write app_config"
  on app_config for all
  using ( is_staff() )
  with check ( is_staff() );


-- =====================================================================
-- 15. SEED DATA (matches live: one row in `constituencies`)
-- =====================================================================

-- The live DB has exactly one constituency row (id = 1, Balussery).
-- local_bodies / wards / mlas are unseeded; staff can populate them
-- via the admin portal. If you need richer first-deploy data, add it
-- in a separate seed file rather than expanding this one — that keeps
-- this file a faithful mirror of the production shape.
insert into constituencies (name, state)
select 'Balussery', 'Kerala'
where not exists (select 1 from constituencies c where c.name ilike 'Balussery');

-- Storage: bucket `media` (avatars, etc.), public read if needed for URLs.
-- Bucket `submission-objects`: paths `problems|ideas|improvements|appreciations/{auth_user_id}/…`.
