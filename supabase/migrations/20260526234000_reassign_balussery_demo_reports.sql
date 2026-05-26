-- Assign Balussery demo reports to Shamli (919999999993) and make them public.

do $$
declare
  reporter bigint;
  c_balussery bigint;
begin
  select id into c_balussery from constituencies where name = 'Balussery' limit 1;

  if c_balussery is null then
    return;
  end if;

  select c.id
  into reporter
  from citizens c
  where c.deleted_at is null
    and c.constituency_id = c_balussery
    and c.phone in ('919999999993', '+919999999993')
  limit 1;

  if reporter is null then
    raise notice 'Citizen not found for 919999999993 in Balussery';
    return;
  end if;

  update submissions
  set
    reporter_id = reporter,
    visibility = 'public',
    is_anonymous = false
  where reference_id in (
    '7a4b6c4c-1c57-4c1d-bc33-6d7d8f4b9e01',
    'b60a8e2b-9d5d-4bdb-8c2a-5c8d2c3a0a12',
    '2c6d3f88-5c2a-4b8a-9a20-1bd2d8c9e913',
    'e41f9a6d-8b2c-4f1e-a3d0-9c7e5b4a1f02'
  );
end $$;
