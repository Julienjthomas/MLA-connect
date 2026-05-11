-- =====================================================================
-- SUPER BALUSSERY — SUPABASE SCHEMA (Citizen + Staff app shared DB)
-- =====================================================================
-- Two apps share this Postgres:
--   1. Citizen app  → users in `profiles`, role-bound by RLS
--   2. Staff app    → users in `mla_staff`, role-bound by RLS
-- Both authenticate against auth.users; a user belongs to exactly one
-- of the two tables (enforced at signup).
-- =====================================================================


-- =====================================================================
-- 1. GEOGRAPHY
-- =====================================================================

create table constituencies (
  id          uuid primary key default gen_random_uuid(),
  name        text not null,
  state       text not null default 'Kerala',
  created_at  timestamptz not null default now()
);

create table local_bodies (
  id              uuid primary key default gen_random_uuid(),
  constituency_id uuid not null references constituencies(id) on delete restrict,
  name            text not null,
  type            text not null,                       -- 'panchayat'|'municipality'|'corporation'
  created_at      timestamptz not null default now(),
  unique (constituency_id, name, type)
);

create index idx_local_bodies_constituency on local_bodies(constituency_id);

create table wards (
  id            uuid primary key default gen_random_uuid(),
  local_body_id uuid not null references local_bodies(id) on delete cascade,
  ward_number   int  not null,
  name          text not null,
  created_at    timestamptz not null default now(),
  unique (local_body_id, ward_number)
);

create index idx_wards_local_body on wards(local_body_id);


-- =====================================================================
-- 2. MLA
-- =====================================================================

create table mlas (
  id              uuid primary key default gen_random_uuid(),
  constituency_id uuid not null references constituencies(id) on delete restrict,
  full_name       text not null,
  photo_url       text,
  cover_image_url text,
  term_label      text,
  serving_since   date,
  bio             text,
  office_phone    text,
  office_email    text,
  office_address  text,
  is_current      boolean not null default true,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);

create index idx_mlas_constituency on mlas(constituency_id) where is_current;


-- =====================================================================
-- 3. CITIZEN PROFILES
-- =====================================================================

create table profiles (
  id              uuid primary key references auth.users(id) on delete cascade,
  full_name       text not null,
  email           text,
  phone           text not null,
  avatar_url      text,
  language        text not null default 'en',
  local_body_id   uuid references local_bodies(id) on delete set null,
  ward_id         uuid references wards(id) on delete set null,
  onboarded_at    timestamptz,
  deleted_at      timestamptz,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);

create index idx_profiles_ward       on profiles(ward_id);
create index idx_profiles_local_body on profiles(local_body_id);


-- =====================================================================
-- 4. MLA STAFF
-- =====================================================================

create table mla_staff (
  id              uuid primary key references auth.users(id) on delete cascade,
  mla_id          uuid references mlas(id) on delete set null,
  full_name       text not null,
  designation     text,
  role            text not null default 'staff',       -- 'mla'|'staff'|'admin'
  photo_url       text,
  phone           text not null,
  email           text,
  office_address  text,
  local_body_id   uuid references local_bodies(id) on delete set null,
  is_public       boolean not null default true,
  position        int not null default 0,
  is_active       boolean not null default true,
  last_login_at   timestamptz,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);

create index idx_mla_staff_mla        on mla_staff(mla_id);
create index idx_mla_staff_local_body on mla_staff(local_body_id);
create index idx_mla_staff_role       on mla_staff(role);
create index idx_mla_staff_public     on mla_staff(is_public, position) where is_public and is_active;


-- =====================================================================
-- 5. PROJECTS
-- =====================================================================

create table projects (
  id              uuid primary key default gen_random_uuid(),
  mla_id          uuid references mlas(id) on delete set null,
  title           text not null,
  description     text,
  category        text,
  status          text not null default 'planned',     -- 'planned'|'active'|'on_hold'|'completed'|'cancelled'
  budget          numeric(14,2),
  budget_currency text default 'INR',
  started_at      date,
  completed_at    date,
  local_body_id   uuid references local_bodies(id),
  ward_id         uuid references wards(id),
  cover_image_url text,
  created_by      uuid references mla_staff(id) on delete set null,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);

create index idx_projects_mla        on projects(mla_id);
create index idx_projects_status     on projects(status);
create index idx_projects_ward       on projects(ward_id);
create index idx_projects_local_body on projects(local_body_id);


-- =====================================================================
-- 6. EVENTS
-- =====================================================================

create table events (
  id              uuid primary key default gen_random_uuid(),
  title           text not null,
  description     text,
  kind            text not null default 'general',
  starts_at       timestamptz not null,
  ends_at         timestamptz,
  venue_name      text,
  venue_address   text,
  local_body_id   uuid references local_bodies(id),
  ward_id         uuid references wards(id),
  cover_image_url text,
  created_by      uuid references mla_staff(id) on delete set null,
  is_cancelled    boolean not null default false,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);

create index idx_events_starts on events(starts_at);

create table event_rsvps (
  event_id    uuid not null references events(id) on delete cascade,
  user_id     uuid not null references profiles(id) on delete cascade,
  status      text not null default 'interested',
  created_at  timestamptz not null default now(),
  primary key (event_id, user_id)
);


-- =====================================================================
-- 7. SUBMISSIONS
-- =====================================================================

create table submissions (
  id                uuid primary key default gen_random_uuid(),
  reference_id      text not null unique,
  kind              text not null,                     -- 'report'|'appreciation'|'idea'|'suggestion'
  reporter_id       uuid not null references profiles(id) on delete restrict,

  title             text not null,
  description       text not null,
  category          text,
  topic             text,
  voice_message_url text,

  local_body_id     uuid references local_bodies(id),
  ward_id           uuid references wards(id),
  landmark          text,
  pin_latitude      numeric(9,6),
  pin_longitude     numeric(9,6),
  pin_address       text,
  contact_phone     text,

  target_type           text,
  recipient_staff_name  text,
  recipient_department  text,
  related_project_name  text,

  benefits                text,
  beneficiaries           text[] not null default '{}',
  estimated_cost_min      numeric(14,2),
  estimated_cost_max      numeric(14,2),
  estimated_cost_currency text default 'INR',

  visibility                  text,
  is_anonymous                boolean not null default false,
  allow_community_discussion  boolean,
  allow_mla_office_contact    boolean,

  status              text not null default 'submitted',
  assigned_department text,
  assigned_staff_id   uuid references mla_staff(id) on delete set null,
  resolved_at         timestamptz,
  resolution_notes    text,

  view_count        int not null default 0,
  like_count        int not null default 0,
  share_count       int not null default 0,
  comment_count     int not null default 0,

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

create table submission_status_history (
  id            uuid primary key default gen_random_uuid(),
  submission_id uuid not null references submissions(id) on delete cascade,
  from_status   text,
  to_status     text not null,
  changed_by    uuid references mla_staff(id) on delete set null,
  notes         text,
  created_at    timestamptz not null default now()
);

create index idx_status_history_submission on submission_status_history(submission_id, created_at desc);


-- =====================================================================
-- 8. UPDATES
-- =====================================================================

create table updates (
  id              uuid primary key default gen_random_uuid(),
  author_id       uuid references mla_staff(id) on delete set null,
  author_name     text,
  title           text not null,
  body            text,
  cover_image_url text,
  category        text not null,
  tags            text[] not null default '{}',
  priority        text not null default 'normal',      -- 'normal'|'important'|'urgent'
  related_submission_id uuid references submissions(id) on delete set null,
  related_event_id      uuid references events(id) on delete set null,
  project_id            uuid references projects(id) on delete set null,
  local_body_id   uuid references local_bodies(id),
  ward_id         uuid references wards(id),
  is_pinned       boolean not null default false,
  published_at    timestamptz not null default now(),
  expires_at      timestamptz,
  deleted_at      timestamptz,
  view_count      int not null default 0,
  like_count      int not null default 0,
  share_count     int not null default 0,
  comment_count   int not null default 0,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);

create index idx_updates_category   on updates(category);
create index idx_updates_published  on updates(published_at desc);
create index idx_updates_ward       on updates(ward_id);
create index idx_updates_local_body on updates(local_body_id);
create index idx_updates_project    on updates(project_id);
create index idx_updates_pinned     on updates(is_pinned, published_at desc) where is_pinned;
create index idx_updates_priority   on updates(priority, published_at desc) where priority <> 'normal';


-- =====================================================================
-- 9. POLYMORPHIC MEDIA & ENGAGEMENT
-- =====================================================================

create table media_attachments (
  id               uuid primary key default gen_random_uuid(),
  attachable_type  text not null,
  attachable_id    uuid not null,
  kind             text not null,
  storage_path     text not null,
  url              text,
  position         int not null default 0,
  caption          text,
  size_bytes       bigint,
  mime_type        text,
  duration_seconds int,
  uploaded_by      uuid references profiles(id) on delete set null,
  created_at       timestamptz not null default now()
);

create index idx_media_attachable on media_attachments(attachable_type, attachable_id);

create table likes (
  user_id      uuid not null references profiles(id) on delete cascade,
  target_type  text not null,
  target_id    uuid not null,
  created_at   timestamptz not null default now(),
  primary key (user_id, target_type, target_id)
);

create index idx_likes_target on likes(target_type, target_id);

create table saves (
  user_id      uuid not null references profiles(id) on delete cascade,
  target_type  text not null,
  target_id    uuid not null,
  created_at   timestamptz not null default now(),
  primary key (user_id, target_type, target_id)
);

create index idx_saves_user on saves(user_id, created_at desc);

create table shares (
  id           uuid primary key default gen_random_uuid(),
  user_id      uuid references profiles(id) on delete set null,
  target_type  text not null,
  target_id    uuid not null,
  channel      text,
  created_at   timestamptz not null default now()
);

create index idx_shares_target on shares(target_type, target_id);

create table comments (
  id           uuid primary key default gen_random_uuid(),
  author_id    uuid not null references profiles(id) on delete cascade,
  target_type  text not null,
  target_id    uuid not null,
  parent_id    uuid references comments(id) on delete cascade,
  body         text not null,
  is_deleted   boolean not null default false,
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now()
);

create index idx_comments_target on comments(target_type, target_id, created_at desc);
create index idx_comments_parent on comments(parent_id);


-- =====================================================================
-- 10. HALL OF EXCELLENCE
-- =====================================================================

create table achievement_categories (
  id          uuid primary key default gen_random_uuid(),
  title       text not null,
  subtitle    text,
  year        int,
  is_active   boolean not null default true,
  position    int not null default 0,
  created_at  timestamptz not null default now()
);

create table achievers (
  id            uuid primary key default gen_random_uuid(),
  category_id   uuid not null references achievement_categories(id) on delete cascade,
  full_name     text not null,
  institution   text,
  grade         text,
  photo_url     text,
  ward_id       uuid references wards(id) on delete set null,
  position      int not null default 0,
  created_at    timestamptz not null default now()
);

create index idx_achievers_category on achievers(category_id, position);


-- =====================================================================
-- 11. NOTIFICATIONS
-- =====================================================================

create table notification_preferences (
  user_id            uuid primary key references profiles(id) on delete cascade,
  issue_updates      boolean not null default true,
  mla_announcements  boolean not null default true,
  event_reminders    boolean not null default true,
  emergency_alerts   boolean not null default false,
  push_token         text,
  push_platform      text,
  updated_at         timestamptz not null default now()
);

create table notifications (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null references profiles(id) on delete cascade,
  type        text not null,
  channel     text not null,
  title       text not null,
  body        text,
  target_type text,
  target_id   uuid,
  is_read     boolean not null default false,
  read_at     timestamptz,
  created_at  timestamptz not null default now()
);

create index idx_notif_user_unread on notifications(user_id, is_read, created_at desc);
create index idx_notif_user_recent on notifications(user_id, created_at desc);


-- =====================================================================
-- 12. SUPPORT
-- =====================================================================

create table faqs (
  id          uuid primary key default gen_random_uuid(),
  question    text not null,
  answer      text not null,
  language    text not null default 'en',
  category    text,
  position    int not null default 0,
  is_active   boolean not null default true,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

create index idx_faqs_active on faqs(language, position) where is_active;

create table contact_messages (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid references profiles(id) on delete set null,
  subject     text not null,
  body        text not null,
  status      text not null default 'open',
  handled_by  uuid references mla_staff(id) on delete set null,
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

create table audit_log (
  id           bigserial primary key,
  actor_id     uuid,
  actor_type   text,
  action       text not null,
  target_type  text,
  target_id    uuid,
  metadata     jsonb,
  created_at   timestamptz not null default now()
);

create index idx_audit_target on audit_log(target_type, target_id, created_at desc);
create index idx_audit_actor  on audit_log(actor_id, created_at desc);

create table banners (
  id              uuid primary key default gen_random_uuid(),
  title           text not null,
  body            text,
  priority        text not null default 'info',
  action_label    text,
  action_url      text,
  local_body_id   uuid references local_bodies(id),
  ward_id         uuid references wards(id),
  starts_at       timestamptz not null default now(),
  ends_at         timestamptz,
  is_active       boolean not null default true,
  created_by      uuid references mla_staff(id) on delete set null,
  created_at      timestamptz not null default now()
);

create index idx_banners_active on banners(is_active, starts_at, ends_at);

create table content_flags (
  id            uuid primary key default gen_random_uuid(),
  flagger_id    uuid not null references profiles(id) on delete cascade,
  target_type   text not null,
  target_id     uuid not null,
  reason        text not null,
  details       text,
  status        text not null default 'pending',
  reviewed_by   uuid references mla_staff(id) on delete set null,
  reviewed_at   timestamptz,
  created_at    timestamptz not null default now()
);

create index idx_flags_status on content_flags(status, created_at desc);
create index idx_flags_target on content_flags(target_type, target_id);

create table submission_drafts (
  id            uuid primary key default gen_random_uuid(),
  user_id       uuid not null references profiles(id) on delete cascade,
  kind          text not null,
  step          int not null default 1,
  data          jsonb not null default '{}',
  expires_at    timestamptz not null default (now() + interval '30 days'),
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now()
);

create index idx_drafts_user on submission_drafts(user_id, updated_at desc);

create table search_queries (
  id           bigserial primary key,
  user_id      uuid references profiles(id) on delete set null,
  query        text not null,
  result_count int,
  created_at   timestamptz not null default now()
);

create index idx_search_recent on search_queries(created_at desc);

create table app_config (
  key         text primary key,
  value       jsonb not null,
  description text,
  updated_by  uuid references mla_staff(id) on delete set null,
  updated_at  timestamptz not null default now()
);


-- =====================================================================
-- 14. VIEWS
-- =====================================================================

create or replace view v_my_activity_counts as
select
  p.id as user_id,
  count(*) filter (where s.kind = 'report')                                  as reports_submitted,
  count(*) filter (where s.kind = 'report' and s.status = 'resolved')        as reports_resolved,
  count(*) filter (where s.kind = 'idea')                                    as ideas_shared,
  count(*) filter (where s.kind = 'appreciation')                            as appreciations_sent,
  count(*) filter (where s.kind = 'suggestion')                              as suggestions_made
from profiles p
left join submissions s on s.reporter_id = p.id and s.deleted_at is null
group by p.id;

create or replace view v_mla_stats as
select
  m.id as mla_id,
  (select count(*) from submissions where kind = 'report'       and deleted_at is null)                          as issues_total,
  (select count(*) from submissions where kind = 'report'       and status = 'resolved' and deleted_at is null)  as issues_resolved,
  (select count(*) from projects    where status = 'active'     and mla_id = m.id)                               as active_projects,
  (select count(*) from submissions where kind = 'appreciation' and deleted_at is null)                          as appreciations_count,
  (select count(*) from submissions where kind = 'idea'         and status = 'implemented' and deleted_at is null) as ideas_implemented
from mlas m;

create or replace view v_unread_notifications as
select user_id, count(*) as unread
from notifications
where is_read = false
group by user_id;


-- =====================================================================
-- 15. ROW LEVEL SECURITY
-- =====================================================================

create or replace function is_staff() returns boolean
language sql stable security definer as $$
  select exists (
    select 1 from mla_staff where id = auth.uid() and is_active
  );
$$;

-- profiles
alter table profiles enable row level security;
create policy "read own profile"   on profiles for select using ( auth.uid() = id );
create policy "update own profile" on profiles for update using ( auth.uid() = id ) with check ( auth.uid() = id );
create policy "insert own profile" on profiles for insert with check ( auth.uid() = id );

-- submissions
alter table submissions enable row level security;
create policy "read submissions" on submissions for select
  using ( auth.uid() = reporter_id or visibility = 'public' or (kind = 'report' and is_anonymous = false) );
create policy "create own submissions" on submissions for insert with check ( auth.uid() = reporter_id );
create policy "update own submissions" on submissions for update using ( auth.uid() = reporter_id ) with check ( auth.uid() = reporter_id );
create policy "staff full access submissions" on submissions for all using ( is_staff() ) with check ( is_staff() );

-- updates
alter table updates enable row level security;
create policy "read updates"      on updates for select using ( deleted_at is null );
create policy "staff write updates" on updates for all using ( is_staff() ) with check ( is_staff() );

-- likes
alter table likes enable row level security;
create policy "read likes"       on likes for select using ( true );
create policy "insert own likes" on likes for insert with check ( auth.uid() = user_id );
create policy "delete own likes" on likes for delete using ( auth.uid() = user_id );

-- public read-only
alter table local_bodies enable row level security;
alter table wards        enable row level security;
alter table mlas         enable row level security;
alter table mla_staff    enable row level security;
alter table notification_preferences enable row level security;
alter table media_attachments        enable row level security;
alter table submission_status_history enable row level security;

create policy "local_bodies_read" on local_bodies for select using ( true );
create policy "wards_read"        on wards        for select using ( true );
create policy "mlas_read"         on mlas         for select using ( true );
create policy "mla_staff_read"    on mla_staff    for select using ( is_public = true );

create policy "notif_prefs_own" on notification_preferences
  for all using ( auth.uid() = user_id ) with check ( auth.uid() = user_id );

create policy "media_select_authed" on media_attachments for select using ( auth.role() = 'authenticated' );
create policy "media_insert_authed" on media_attachments for insert with check ( auth.role() = 'authenticated' );

create policy "status_history_select" on submission_status_history for select
  using ( exists ( select 1 from submissions s where s.id = submission_id and s.reporter_id = auth.uid() ) );


-- =====================================================================
-- SEED DATA
-- =====================================================================

insert into constituencies (id, name) values
  ('00000000-0000-0000-0000-000000000001', 'Balussery')
on conflict do nothing;

insert into local_bodies (id, constituency_id, name, type) values
  ('00000000-0000-0000-0001-000000000001', '00000000-0000-0000-0000-000000000001', 'Balussery',   'panchayat'),
  ('00000000-0000-0000-0001-000000000002', '00000000-0000-0000-0000-000000000001', 'Kodenchery',  'panchayat'),
  ('00000000-0000-0000-0001-000000000003', '00000000-0000-0000-0000-000000000001', 'Koorachundu', 'panchayat'),
  ('00000000-0000-0000-0001-000000000004', '00000000-0000-0000-0000-000000000001', 'Veliyal',     'panchayat')
on conflict do nothing;

insert into wards (local_body_id, ward_number, name) values
  ('00000000-0000-0000-0001-000000000001', 1,  'Puthiyangadi'),
  ('00000000-0000-0000-0001-000000000001', 2,  'Chemmad'),
  ('00000000-0000-0000-0001-000000000001', 3,  'Kuttikattoor Town'),
  ('00000000-0000-0000-0001-000000000001', 4,  'Valayamkulam'),
  ('00000000-0000-0000-0001-000000000001', 5,  'Parappanangadi'),
  ('00000000-0000-0000-0001-000000000001', 6,  'Edavanna'),
  ('00000000-0000-0000-0001-000000000001', 7,  'Mampad'),
  ('00000000-0000-0000-0001-000000000001', 8,  'Tiruvali'),
  ('00000000-0000-0000-0001-000000000001', 9,  'Koottilangadi'),
  ('00000000-0000-0000-0001-000000000001', 10, 'Tanur'),
  ('00000000-0000-0000-0001-000000000001', 11, 'Tirur'),
  ('00000000-0000-0000-0001-000000000001', 12, 'Vettom'),
  ('00000000-0000-0000-0001-000000000001', 13, 'Vengara'),
  ('00000000-0000-0000-0001-000000000001', 14, 'Moothedam'),
  ('00000000-0000-0000-0001-000000000001', 15, 'Thazhekode')
on conflict do nothing;

insert into mlas (id, constituency_id, full_name, bio, term_label, office_phone, office_email, office_address, is_current) values
  (
    '00000000-0000-0000-0000-000000000010',
    '00000000-0000-0000-0000-000000000001',
    'V T Sooraj',
    'Working for the overall development of Balussery. Focused on infrastructure, education, health and environmental sustainability.',
    '3rd Term MLA',
    '+91 9847 123 456',
    'mla@balussery.kerala.gov.in',
    'MLA Office, Balussery, Kozhikode, Kerala – 673612',
    true
  )
on conflict do nothing;

-- ─────────────────────────────────────────
-- STORAGE BUCKET
-- Run separately:
--   Dashboard → Storage → New Bucket → name: "media", Public: ON
-- ─────────────────────────────────────────
