-- Seed Kozhikode South constituency + local body + wards + MLA: Adv. Fyzal Babu (IUML).
-- Kozhikode South is an urban seat: its wards are corporation divisions of the
-- Kozhikode Municipal Corporation (not rural panchayats).
-- Idempotent: skips rows that already exist by name; backfills MLA bio if empty.
do $$
declare
  c_kozhikode_south bigint;
  lb_corporation    bigint;
begin
  -- ── Constituency (create if missing) ────────────
  select id into c_kozhikode_south
  from constituencies
  where name = 'Kozhikode South'
  limit 1;

  if c_kozhikode_south is null then
    insert into constituencies (name, state, is_active)
    values ('Kozhikode South', 'Kerala', true)
    returning id into c_kozhikode_south;
  end if;

  -- ── Local body: Kozhikode Municipal Corporation ──
  select id into lb_corporation
  from local_bodies
  where name = 'Kozhikode Municipal Corporation' and constituency_id = c_kozhikode_south
  limit 1;

  if lb_corporation is null then
    insert into local_bodies (constituency_id, name, type, is_active)
    values (c_kozhikode_south, 'Kozhikode Municipal Corporation', 'corporation', true)
    returning id into lb_corporation;
  end if;

  -- ── Wards (corporation divisions in Kozhikode South) ──
  insert into wards (local_body_id, ward_number, name)
  select lb_corporation, v.num, 'Ward - ' || v.num || ' ' || v.nm
  from (values
    (22, 'Kovoor'),        (23, 'Nellikode'),     (27, 'Puthiyara'),
    (28, 'Kuthiravattom'), (29, 'Pottammal'),     (30, 'Kommery'),
    (31, 'Kuttiyilthazham'),(32, 'Pokkunnu'),     (33, 'Kinassery'),
    (34, 'Mankavu'),       (35, 'Azhchavattom'),  (36, 'Kallayi'),
    (37, 'Panniyankara'),  (38, 'Meenchanda'),    (39, 'Thiruvannur'),
    (54, 'Kappakkal'),     (55, 'Payyanakkal'),   (56, 'Chakkumkadavu'),
    (57, 'Mukhador'),      (58, 'Kuttichira'),    (59, 'Chalappuram'),
    (60, 'Palayam'),       (61, 'Valiyangadi')
  ) as v(num, nm)
  where not exists (
    select 1 from wards w where w.local_body_id = lb_corporation and w.ward_number = v.num
  );

  -- ── MLA ──────────────────────────────────────────
  if c_kozhikode_south is not null then
    insert into mlas (constituency_id, full_name, term_label, serving_since, bio, is_current)
    values (
      c_kozhikode_south,
      'Adv. Fyzal Babu',
      'MLA, Kozhikode South',
      '2026-05-20',
      'Adv. Fyzal Babu of the Indian Union Muslim League (IUML) is the MLA representing the Kozhikode South constituency since 2026. An advocate of the High Court of Kerala, youth leader and public speaker, he holds an M.A. in Sociology from Calicut University (2018) and an LLB from Kannur University (2017). He serves as National Assistant Secretary of the IUML and contested as the UDF candidate for Kozhikode South. He won the seat with 52,680 votes, retaining it for the IUML by a margin of 5,294 votes over his nearest rival, Ahammad Devarkovil.',
      true
    )
    on conflict do nothing;

    update mlas
    set
      full_name     = 'Adv. Fyzal Babu',
      term_label    = 'MLA, Kozhikode South',
      serving_since = '2026-05-20',
      bio           = 'Adv. Fyzal Babu of the Indian Union Muslim League (IUML) is the MLA representing the Kozhikode South constituency since 2026. An advocate of the High Court of Kerala, youth leader and public speaker, he holds an M.A. in Sociology from Calicut University (2018) and an LLB from Kannur University (2017). He serves as National Assistant Secretary of the IUML and contested as the UDF candidate for Kozhikode South. He won the seat with 52,680 votes, retaining it for the IUML by a margin of 5,294 votes over his nearest rival, Ahammad Devarkovil.',
      updated_at    = now()
    where constituency_id = c_kozhikode_south and is_current = true and (bio is null or bio = '');
  end if;
end $$;
