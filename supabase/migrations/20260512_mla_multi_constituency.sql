-- MLA multi-constituency + office messages (citizen app)
-- QA: Balussery ward-count targets total 146 (see openspec change design).

-- ---------------------------------------------------------------------------
-- Constituencies: slugs + seed Koduvalli & Perambra (Balussery may already exist)
-- ---------------------------------------------------------------------------
alter table constituencies add column if not exists slug text;

update constituencies set slug = 'balussery'
  where id = '00000000-0000-0000-0000-000000000001' or (name ilike 'Balussery' and slug is null);

insert into constituencies (id, name, slug)
values
  ('00000000-0000-0000-0000-000000000002', 'Koduvalli', 'koduvalli'),
  ('00000000-0000-0000-0000-000000000003', 'Perambra', 'perambra')
on conflict (id) do update set name = excluded.name, slug = excluded.slug;

-- ---------------------------------------------------------------------------
-- Citizens profile: assembly constituency context (app uses table `citizens`)
-- ---------------------------------------------------------------------------
alter table if exists citizens add column if not exists constituency_id uuid references constituencies(id);

create index if not exists idx_citizens_constituency on citizens(constituency_id);

-- ---------------------------------------------------------------------------
-- Office messages (citizen → MLA office)
-- ---------------------------------------------------------------------------
create table if not exists office_messages (
  id                uuid primary key default gen_random_uuid(),
  user_id           uuid not null references auth.users(id) on delete cascade,
  constituency_id   uuid not null references constituencies(id) on delete restrict,
  category          text not null,
  body              text not null,
  created_at        timestamptz not null default now()
);

create index if not exists idx_office_messages_user_created
  on office_messages(user_id, created_at desc);

create index if not exists idx_office_messages_constituency_created
  on office_messages(constituency_id, created_at desc);

alter table office_messages enable row level security;

drop policy if exists "office_messages_select_own" on office_messages;
create policy "office_messages_select_own" on office_messages
  for select using (auth.uid() = user_id);

drop policy if exists "office_messages_insert_own" on office_messages;
create policy "office_messages_insert_own" on office_messages
  for insert with check (auth.uid() = user_id);

-- ---------------------------------------------------------------------------
-- Seed placeholder MLAs for new constituencies (replace with real data later)
-- ---------------------------------------------------------------------------
insert into mlas (id, constituency_id, full_name, bio, term_label, office_phone, office_email, office_address, is_current)
values
  (
    '00000000-0000-0000-0000-000000000020',
    '00000000-0000-0000-0000-000000000002',
    'MLA (Koduvalli)',
    'Constituency representative.',
    '',
    '',
    null,
    null,
    true
  ),
  (
    '00000000-0000-0000-0000-000000000021',
    '00000000-0000-0000-0000-000000000003',
    'MLA (Perambra)',
    'Constituency representative.',
    '',
    '',
    null,
    null,
    true
  )
on conflict (id) do nothing;
