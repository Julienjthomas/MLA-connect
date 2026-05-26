-- Add custom local body label under Balussery.
-- Idempotent: skips if already present.

do $$
declare
  c_balussery bigint;
begin
  select id into c_balussery from constituencies where name = 'Balussery' limit 1;
  if c_balussery is null then
    insert into constituencies (name, state, is_active)
    values ('Balussery', 'Kerala', true)
    returning id into c_balussery;
  end if;

  insert into local_bodies (constituency_id, name, type, is_active)
  select c_balussery, v.name, 'panchayat', true
  from (values ('Above All')) as v(name)
  where not exists (
    select 1 from local_bodies lb
    where lb.name = v.name and lb.constituency_id = c_balussery
  );
end $$;

