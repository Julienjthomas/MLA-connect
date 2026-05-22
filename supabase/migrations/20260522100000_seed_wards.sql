-- Seed constituencies, local_bodies, and wards.
-- Idempotent: skips rows that already exist by name.

do $$
declare
  c_balussery bigint;
  c_koduvalli bigint;
  c_perambra  bigint;
  lb_id       bigint;
  ward_count  int;
  i           int;
begin

  -- ── Constituencies ──────────────────────────────

  select id into c_balussery from constituencies where name = 'Balussery' limit 1;
  if c_balussery is null then
    insert into constituencies (name, state, is_active) values ('Balussery', 'Kerala', true)
    returning id into c_balussery;
  end if;

  select id into c_koduvalli from constituencies where name = 'Koduvalli' limit 1;
  if c_koduvalli is null then
    insert into constituencies (name, state, is_active) values ('Koduvalli', 'Kerala', true)
    returning id into c_koduvalli;
  end if;

  select id into c_perambra from constituencies where name = 'Perambra' limit 1;
  if c_perambra is null then
    insert into constituencies (name, state, is_active) values ('Perambra', 'Kerala', true)
    returning id into c_perambra;
  end if;

  -- ── Local Bodies ────────────────────────────────

  insert into local_bodies (constituency_id, name, type, is_active)
  select c_balussery, v.name, 'panchayat', true
  from (values ('Atholi'),('Balussery'),('Kayanna'),('Koorachundu'),('Kottur'),
               ('Naduvannur'),('Panangad'),('Ulliyeri'),('Unnikulam')) as v(name)
  where not exists (select 1 from local_bodies lb where lb.name = v.name and lb.constituency_id = c_balussery);

  insert into local_bodies (constituency_id, name, type, is_active)
  select c_koduvalli, v.name, 'panchayat', true
  from (values ('Kodenchery'),('Kizhakkoth'),('Madavoor'),('Narikkuni'),('Omassery'),
               ('Puduppadi'),('Thamarassery'),('Kattippara'),('Kodanchery'),('Koduvalli')) as v(name)
  where not exists (select 1 from local_bodies lb where lb.name = v.name and lb.constituency_id = c_koduvalli);

  insert into local_bodies (constituency_id, name, type, is_active)
  select c_perambra, v.name, 'panchayat', true
  from (values ('Arikkulam'),('Chakkittapara'),('Changaroth'),('Cheruvannur'),('Keezhariyur'),
               ('Koothali'),('Meppayur'),('Nochad'),('Perambra'),('Thurayur')) as v(name)
  where not exists (select 1 from local_bodies lb where lb.name = v.name and lb.constituency_id = c_perambra);

  -- ── Wards ───────────────────────────────────────
  -- Loop over each local body + its ward count, insert Ward 1..n if none exist.

  for lb_id, ward_count in
    select lb.id, v.wc
    from local_bodies lb
    join (values
      ('Atholi',       18), ('Balussery', 18), ('Kayanna',    13),
      ('Koorachundu',  15), ('Kottur',    15), ('Naduvannur', 16),
      ('Panangad',     14), ('Ulliyeri',  21), ('Unnikulam',  16)
    ) as v(name, wc) on lb.name = v.name and lb.constituency_id = c_balussery
    where not exists (select 1 from wards w where w.local_body_id = lb.id)
  loop
    for i in 1..ward_count loop
      insert into wards (local_body_id, ward_number, name) values (lb_id, i, 'Ward ' || i);
    end loop;
  end loop;

  -- Koduvalli — 12 wards each (update when real counts known)
  for lb_id in
    select lb.id from local_bodies lb
    where lb.constituency_id = c_koduvalli
      and not exists (select 1 from wards w where w.local_body_id = lb.id)
  loop
    for i in 1..12 loop
      insert into wards (local_body_id, ward_number, name) values (lb_id, i, 'Ward ' || i);
    end loop;
  end loop;

  -- Perambra — 12 wards each (update when real counts known)
  for lb_id in
    select lb.id from local_bodies lb
    where lb.constituency_id = c_perambra
      and not exists (select 1 from wards w where w.local_body_id = lb.id)
  loop
    for i in 1..12 loop
      insert into wards (local_body_id, ward_number, name) values (lb_id, i, 'Ward ' || i);
    end loop;
  end loop;

end $$;
