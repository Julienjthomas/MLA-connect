-- Balussery demo reports: attach to a citizen registered in Balussery constituency.
-- All four reports are public. Prefers Test Citizen (919999999999) when present.
--
-- Notes:
-- - `submissions.reference_id` is a UUID v4 in the app.
-- - We intentionally scope to a single citizen row to avoid spamming every user.
-- - Idempotent via reference_id check.

do $$
declare
  c_balussery bigint;
  reporter bigint;
  lb_mampoyil bigint;
  lb_naduvannur bigint;
  lb_ulliyeri bigint;
begin
  select id into c_balussery from constituencies where name = 'Balussery' limit 1;

  if c_balussery is null then
    return;
  end if;

  -- Prefer Shamli demo account (919999999993), else Test Citizen, else newest.
  select c.id
  into reporter
  from citizens c
  where c.deleted_at is null
    and c.constituency_id = c_balussery
  order by
    case
      when c.phone in ('919999999993', '+919999999993') then 0
      when c.phone = '919999999999' then 1
      else 2
    end,
    c.created_at desc,
    c.id desc
  limit 1;

  if reporter is null then
    raise notice 'No citizen found for Balussery constituency — create/login with Balussery selected, then re-run.';
    return;
  end if;

  select id into lb_mampoyil from local_bodies lb
  where lb.name = 'Mampoyil' and lb.constituency_id = c_balussery limit 1;
  select id into lb_naduvannur from local_bodies lb
  where lb.name = 'Naduvannur' and lb.constituency_id = c_balussery limit 1;
  select id into lb_ulliyeri from local_bodies lb
  where lb.name = 'Ulliyeri' and lb.constituency_id = c_balussery limit 1;

  -- 1) PHC development + IP section (Mampoyil)
  insert into submissions (
    reporter_id,
    kind,
    reference_id,
    category,
    title,
    description,
    pin_address,
    local_body_id,
    visibility,
    is_anonymous,
    status
  )
  select
    reporter,
    'report',
    '7a4b6c4c-1c57-4c1d-bc33-6d7d8f4b9e01',
    'health',
    'മാമ്പോയിൽ PHC വികസനം',
    'മാമ്പോയിൽ പ്രാഥമിക ആരോഗ്യ കേന്ദ്രം (PHC) വികസിപ്പിക്കുകയും ഐ.പി (IP) വിഭാഗം ആരംഭിക്കുകയും ചെയ്ത് കുടുംബാരോഗ്യ കേന്ദ്രമായി (FHC) ഉയർത്തുന്നതിനും ആവശ്യമായ തസ്തികകളും ഫണ്ടും അനുവദിക്കുന്നതിനും നടപടി സ്വീകരിക്കണമെന്ന് അപേക്ഷിക്കുന്നു.',
    'Mampoyil',
    lb_mampoyil,
    'public',
    false,
    'submitted'
  where not exists (
    select 1 from submissions s where s.reference_id = '7a4b6c4c-1c57-4c1d-bc33-6d7d8f4b9e01'
  );

  -- 2) Indoor Stadium (Naduvannur)
  insert into submissions (
    reporter_id,
    kind,
    reference_id,
    category,
    title,
    description,
    pin_address,
    local_body_id,
    visibility,
    is_anonymous,
    status
  )
  select
    reporter,
    'report',
    'b60a8e2b-9d5d-4bdb-8c2a-5c8d2c3a0a12',
    'sports',
    'നടുവണ്ണൂരിൽ ഇൻഡോർ സ്റ്റേഡിയം',
    'നടുവണ്ണൂരിലും സമീപപ്രദേശങ്ങളിലുമുള്ള യുവാക്കളുടെയും വിദ്യാർത്ഥികളുടെയും കായിക പരിശീലനത്തിനും മത്സരങ്ങൾ സംഘടിപ്പിക്കാനും അനുയോജ്യമായ ഒരു അത്യാധുനിക ഇൻഡോർ സ്റ്റേഡിയം നിർമ്മിക്കുന്നതിന് ആവശ്യമായ നടപടികൾ സ്വീകരിക്കണമെന്ന് അപേക്ഷിക്കുന്നു.',
    'Naduvannur',
    lb_naduvannur,
    'public',
    false,
    'submitted'
  where not exists (
    select 1 from submissions s where s.reference_id = 'b60a8e2b-9d5d-4bdb-8c2a-5c8d2c3a0a12'
  );

  -- 3) High-mast light repair (Ulliyeri)
  insert into submissions (
    reporter_id,
    kind,
    reference_id,
    category,
    title,
    description,
    pin_address,
    local_body_id,
    visibility,
    is_anonymous,
    status
  )
  select
    reporter,
    'report',
    '2c6d3f88-5c2a-4b8a-9a20-1bd2d8c9e913',
    'streetlight',
    'ഉള്ളിയേരിയിലെ ഹൈമാസ്റ്റ് ലൈറ്റ്',
    'ഉള്ളിയേരി ടൗണിലെ പ്രധാന ജംഗ്ഷനിലെ ഹൈമാസ്റ്റ് ലൈറ്റ് ദീർഘനാളായി പ്രവർത്തിക്കാത്തതിനാൽ രാത്രികാലങ്ങളിൽ അപകടഭീഷണിയും സ്ത്രീകൾക്ക് സുരക്ഷാഭീതിയും വർധിച്ചിട്ടുണ്ട്. അടിയന്തരമായി അറ്റകുറ്റപ്പണി നടത്തി പുനഃസ്ഥാപിക്കണമെന്ന് അപേക്ഷിക്കുന്നു.',
    'Ulliyeri Town',
    lb_ulliyeri,
    'public',
    false,
    'submitted'
  where not exists (
    select 1 from submissions s where s.reference_id = '2c6d3f88-5c2a-4b8a-9a20-1bd2d8c9e913'
  );

  -- 4) Housing / Life Mission (public)
  insert into submissions (
    reporter_id,
    kind,
    reference_id,
    category,
    title,
    description,
    pin_address,
    visibility,
    is_anonymous,
    status
  )
  select
    reporter,
    'report',
    'e41f9a6d-8b2c-4f1e-a3d0-9c7e5b4a1f02',
    'other',
    'ഭവനരഹിതാവസ്ഥ — Life Mission സഹായം',
    'സ്വന്തമായി സുരക്ഷിതമായ വീടില്ലാത്തതിനാലും കുടുംബത്തിന്റെ സുരക്ഷിതത്വമില്ലായ്മയാലും അനുഭവിക്കുന്ന ദുരിതങ്ങൾക്ക് പരിഹാരം കാണുന്നത് സംബന്ധിച്ച്. പ്രായമായ മാതാപിതാക്കൾ, പ്രായപൂർത്തിയാകാത്ത പെൺകുട്ടികൾ എന്നിവ അടങ്ങുന്ന കുടുംബം വാടകവീടുകൾ അടിക്കടി മാറേണ്ടി വരുന്നതും നിലവിലെ സാഹചര്യത്തിൽ സുരക്ഷിതത്വം ഉറപ്പാക്കാൻ കഴിയാത്തതും ശ്രദ്ധയിൽപ്പെടുത്തുന്നു. സർക്കാരിന്റെ ലൈഫ് മിഷൻ (Life Mission) പദ്ധതിയിലോ മറ്റേതെങ്കിലും ഭവന നിർമ്മാണ പദ്ധതികളിലോ ഉൾപ്പെടുത്തി ഒരു വീട് ലഭിക്കുന്നതിനുള്ള സഹായത്തിനും അടിയന്തര ഇടപെടലിനും അപേക്ഷിക്കുന്നു. വരുമാന സർട്ടിഫിക്കറ്റ്, റേഷൻ കാർഡ്, ആധാർ പകർപ്പുകൾ ഉള്ളടക്കം ചെയ്തിട്ടുണ്ട്.',
  null,
    'public',
    false,
    'submitted'
  where not exists (
    select 1 from submissions s where s.reference_id = 'e41f9a6d-8b2c-4f1e-a3d0-9c7e5b4a1f02'
  );

  -- Ensure all demo rows are public (fixes earlier mla_office_only housing seed).
  update submissions
  set visibility = 'public', is_anonymous = false
  where reference_id in (
    '7a4b6c4c-1c57-4c1d-bc33-6d7d8f4b9e01',
    'b60a8e2b-9d5d-4bdb-8c2a-5c8d2c3a0a12',
    '2c6d3f88-5c2a-4b8a-9a20-1bd2d8c9e913',
    'e41f9a6d-8b2c-4f1e-a3d0-9c7e5b4a1f02'
  );

  -- Re-assign all demo reports to the latest citizen (your current demo login).
  update submissions
  set reporter_id = reporter
  where reference_id in (
    '7a4b6c4c-1c57-4c1d-bc33-6d7d8f4b9e01',
    'b60a8e2b-9d5d-4bdb-8c2a-5c8d2c3a0a12',
    '2c6d3f88-5c2a-4b8a-9a20-1bd2d8c9e913',
    'e41f9a6d-8b2c-4f1e-a3d0-9c7e5b4a1f02'
  );
end $$;

