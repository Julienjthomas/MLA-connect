-- ============================================================
-- Super Balussery — Full Schema
-- Run this in Supabase SQL Editor (Dashboard → SQL Editor)
-- ============================================================

-- ─────────────────────────────────────────
-- Extensions
-- ─────────────────────────────────────────
create extension if not exists "uuid-ossp";

-- ─────────────────────────────────────────
-- GEOGRAPHY LAYER
-- ─────────────────────────────────────────

create table if not exists local_bodies (
  id          uuid primary key default uuid_generate_v4(),
  name        text not null,
  type        text not null default 'panchayat', -- panchayat | municipality | corporation
  created_at  timestamptz not null default now()
);

create table if not exists wards (
  id             uuid primary key default uuid_generate_v4(),
  local_body_id  uuid not null references local_bodies(id) on delete cascade,
  ward_number    int  not null,
  name           text not null,
  created_at     timestamptz not null default now(),
  unique(local_body_id, ward_number)
);

-- ─────────────────────────────────────────
-- USER PROFILE LAYER
-- ─────────────────────────────────────────

create table if not exists profiles (
  id              uuid primary key references auth.users(id) on delete cascade,
  full_name       text not null default '',
  phone           text not null default '',
  email           text,
  avatar_url      text,
  language        text not null default 'en',
  local_body_id   uuid references local_bodies(id),
  ward_id         uuid references wards(id),
  onboarded_at    timestamptz,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);

create table if not exists notification_preferences (
  user_id              uuid primary key references profiles(id) on delete cascade,
  issue_updates        boolean not null default true,
  mla_announcements    boolean not null default true,
  emergency_alerts     boolean not null default true,
  event_reminders      boolean not null default false,
  updated_at           timestamptz not null default now()
);

-- ─────────────────────────────────────────
-- MLA LAYER
-- ─────────────────────────────────────────

create table if not exists mlas (
  id               uuid primary key default uuid_generate_v4(),
  full_name        text not null,
  photo_url        text,
  bio              text not null default '',
  bio_ml           text,
  term_label       text not null default '',
  constituency     text not null default '',
  office_phone     text,
  office_email     text,
  office_address   text,
  is_current       boolean not null default false,
  created_at       timestamptz not null default now()
);

create table if not exists mla_staff (
  id               uuid primary key default uuid_generate_v4(),
  mla_id           uuid not null references mlas(id) on delete cascade,
  full_name        text not null,
  designation      text,
  photo_url        text,
  phone            text not null default '',
  email            text,
  office_address   text,
  position         int  not null default 0,
  is_public        boolean not null default true,
  is_active        boolean not null default true,
  created_at       timestamptz not null default now()
);

-- ─────────────────────────────────────────
-- UPDATES FEED LAYER
-- ─────────────────────────────────────────

create table if not exists updates (
  id               uuid primary key default uuid_generate_v4(),
  title            text not null,
  title_ml         text,
  body             text not null default '',
  body_ml          text,
  category         text not null default 'announcements',
    -- development | events | resolved | announcements
  cover_image_url  text,
  like_count       int  not null default 0,
  view_count       int  not null default 0,
  published_at     timestamptz not null default now(),
  created_at       timestamptz not null default now()
);

create table if not exists likes (
  id           uuid primary key default uuid_generate_v4(),
  user_id      uuid not null references profiles(id) on delete cascade,
  target_type  text not null,  -- 'update'
  target_id    uuid not null,
  created_at   timestamptz not null default now(),
  unique(user_id, target_type, target_id)
);

-- ─────────────────────────────────────────
-- SUBMISSIONS LAYER (reports / ideas / appreciations)
-- ─────────────────────────────────────────

create table if not exists submissions (
  id                          uuid primary key default uuid_generate_v4(),
  reference_id                text not null unique,
  kind                        text not null,
    -- report | idea | appreciation
  reporter_id                 uuid not null references profiles(id) on delete cascade,
  status                      text not null default 'submitted',
    -- submitted | under_review | assigned | in_progress | resolved | rejected
  title                       text not null default '',
  description                 text not null default '',
  visibility                  text not null default 'public',
    -- public | mlaOnly | anonymous

  -- report-specific
  category                    text,
  ward_id                     uuid references wards(id),
  pin_address                 text,
  landmark                    text,
  contact_phone               text,
  voice_message_url           text,

  -- idea-specific
  topic                       text,
  benefits                    text,
  beneficiaries               text[] default '{}',
  allow_community_discussion  boolean default true,
  allow_mla_office_contact    boolean default true,

  -- appreciation-specific
  target_type                 text,
  recipient_staff_name        text,
  recipient_department        text,
  related_project_name        text,
  is_anonymous                boolean default false,

  created_at                  timestamptz not null default now(),
  updated_at                  timestamptz not null default now()
);

create table if not exists media_attachments (
  id               uuid primary key default uuid_generate_v4(),
  attachable_type  text not null,  -- 'submission'
  attachable_id    uuid not null,
  kind             text not null default 'image',
  storage_path     text not null,
  url              text not null,
  created_at       timestamptz not null default now()
);

create index if not exists media_attachments_attachable_idx
  on media_attachments(attachable_type, attachable_id);

create table if not exists submission_status_history (
  id             uuid primary key default uuid_generate_v4(),
  submission_id  uuid not null references submissions(id) on delete cascade,
  to_status      text not null,
  notes          text,
  created_at     timestamptz not null default now()
);

-- ─────────────────────────────────────────
-- MLA STATS VIEW
-- ─────────────────────────────────────────

create or replace view v_mla_stats as
select
  m.id                                                            as mla_id,
  count(distinct s.id) filter (where s.status = 'resolved')      as issues_resolved,
  count(distinct s.id) filter (where s.status in ('submitted','under_review','assigned','in_progress'))
                                                                  as active_projects,
  count(distinct s.id) filter (where s.kind = 'appreciation')    as appreciations_count,
  count(distinct s.id) filter (where s.kind = 'idea' and s.status = 'resolved')
                                                                  as ideas_implemented
from mlas m
left join submissions s on true
group by m.id;

-- ─────────────────────────────────────────
-- UPDATED_AT TRIGGER
-- ─────────────────────────────────────────

create or replace function set_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create or replace trigger profiles_updated_at
  before update on profiles
  for each row execute function set_updated_at();

create or replace trigger submissions_updated_at
  before update on submissions
  for each row execute function set_updated_at();

-- ─────────────────────────────────────────
-- ROW LEVEL SECURITY
-- ─────────────────────────────────────────

alter table profiles               enable row level security;
alter table notification_preferences enable row level security;
alter table submissions            enable row level security;
alter table media_attachments      enable row level security;
alter table submission_status_history enable row level security;
alter table likes                  enable row level security;
alter table local_bodies           enable row level security;
alter table wards                  enable row level security;
alter table updates                enable row level security;
alter table mlas                   enable row level security;
alter table mla_staff              enable row level security;

-- profiles: own row only
create policy "profiles_select_own" on profiles for select using (auth.uid() = id);
create policy "profiles_insert_own" on profiles for insert with check (auth.uid() = id);
create policy "profiles_update_own" on profiles for update using (auth.uid() = id);

-- notification_preferences: own row only
create policy "notif_prefs_all_own" on notification_preferences
  using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- submissions: reporter sees own; public submissions visible to all authed users
create policy "submissions_select_own" on submissions for select
  using (auth.uid() = reporter_id or visibility = 'public');
create policy "submissions_insert_own" on submissions for insert
  with check (auth.uid() = reporter_id);
create policy "submissions_update_own" on submissions for update
  using (auth.uid() = reporter_id);

-- media_attachments: readable by all authed users
create policy "media_select_authed" on media_attachments for select
  using (auth.role() = 'authenticated');
create policy "media_insert_authed" on media_attachments for insert
  with check (auth.role() = 'authenticated');

-- status history: readable by submission owner
create policy "status_history_select" on submission_status_history for select
  using (
    exists (
      select 1 from submissions s
      where s.id = submission_id and s.reporter_id = auth.uid()
    )
  );

-- likes: own rows
create policy "likes_select_all"  on likes for select using (auth.role() = 'authenticated');
create policy "likes_insert_own"  on likes for insert with check (auth.uid() = user_id);
create policy "likes_delete_own"  on likes for delete using (auth.uid() = user_id);

-- public read-only tables
create policy "local_bodies_read" on local_bodies for select using (true);
create policy "wards_read"        on wards        for select using (true);
create policy "updates_read"      on updates      for select using (true);
create policy "mlas_read"         on mlas         for select using (true);
create policy "mla_staff_read"    on mla_staff    for select using (is_public = true);

-- ─────────────────────────────────────────
-- SEED DATA — Balussery Panchayat
-- ─────────────────────────────────────────

insert into local_bodies (id, name, type) values
  ('00000000-0000-0000-0000-000000000001', 'Balussery', 'panchayat'),
  ('00000000-0000-0000-0000-000000000002', 'Kodenchery', 'panchayat'),
  ('00000000-0000-0000-0000-000000000003', 'Koorachundu', 'panchayat'),
  ('00000000-0000-0000-0000-000000000004', 'Veliyal', 'panchayat')
on conflict do nothing;

insert into wards (local_body_id, ward_number, name) values
  ('00000000-0000-0000-0000-000000000001', 1,  'Puthiyangadi'),
  ('00000000-0000-0000-0000-000000000001', 2,  'Chemmad'),
  ('00000000-0000-0000-0000-000000000001', 3,  'Kuttikattoor Town'),
  ('00000000-0000-0000-0000-000000000001', 4,  'Valayamkulam'),
  ('00000000-0000-0000-0000-000000000001', 5,  'Parappanangadi'),
  ('00000000-0000-0000-0000-000000000001', 6,  'Edavanna'),
  ('00000000-0000-0000-0000-000000000001', 7,  'Mampad'),
  ('00000000-0000-0000-0000-000000000001', 8,  'Tiruvali'),
  ('00000000-0000-0000-0000-000000000001', 9,  'Koottilangadi'),
  ('00000000-0000-0000-0000-000000000001', 10, 'Tanur'),
  ('00000000-0000-0000-0000-000000000001', 11, 'Tirur'),
  ('00000000-0000-0000-0000-000000000001', 12, 'Vettom'),
  ('00000000-0000-0000-0000-000000000001', 13, 'Vengara'),
  ('00000000-0000-0000-0000-000000000001', 14, 'Moothedam'),
  ('00000000-0000-0000-0000-000000000001', 15, 'Thazhekode')
on conflict do nothing;

insert into mlas (id, full_name, bio, term_label, constituency, office_phone, office_email, office_address, is_current) values
  (
    '00000000-0000-0000-0000-000000000010',
    'V T Sooraj',
    'Working for the overall development of Balussery. Focused on infrastructure, education, health and environmental sustainability.',
    '3rd Term MLA',
    'Balussery Constituency',
    '+91 9847 123 456',
    'mla@balussery.kerala.gov.in',
    'MLA Office, Balussery, Kozhikode, Kerala – 673612',
    true
  )
on conflict do nothing;

-- ─────────────────────────────────────────
-- STORAGE BUCKET
-- Run separately if the bucket doesn't exist yet:
--   Dashboard → Storage → New Bucket → name: "media", Public: ON
-- ─────────────────────────────────────────
