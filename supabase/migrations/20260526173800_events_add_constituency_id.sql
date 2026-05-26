-- Add constituency scope to events so citizen app can filter per constituency.
-- Backfill uses local_body → constituency when present, else created_by → staff → MLA → constituency.

alter table events
add column if not exists constituency_id bigint references constituencies(id) on delete set null;

create index if not exists idx_events_constituency on events(constituency_id);

-- 1) Backfill from local body when scoped.
update events e
set constituency_id = lb.constituency_id
from local_bodies lb
where e.constituency_id is null
  and e.local_body_id is not null
  and e.local_body_id = lb.id;

-- 2) Backfill remaining from created_by → mla.
update events e
set constituency_id = m.constituency_id
from mla_staff ms
join mlas m on m.id = ms.mla_id
where e.constituency_id is null
  and e.created_by is not null
  and e.created_by = ms.id;

create or replace function set_events_constituency_id()
returns trigger
language plpgsql
as $$
declare
  cid bigint;
begin
  if new.constituency_id is not null then
    return new;
  end if;

  if new.local_body_id is not null then
    select lb.constituency_id into cid
    from local_bodies lb
    where lb.id = new.local_body_id
    limit 1;
  end if;

  if cid is null and new.created_by is not null then
    select m.constituency_id into cid
    from mla_staff ms
    join mlas m on m.id = ms.mla_id
    where ms.id = new.created_by
    limit 1;
  end if;

  new.constituency_id = cid;
  return new;
end;
$$;

drop trigger if exists trg_set_events_constituency_id on events;
create trigger trg_set_events_constituency_id
before insert or update of local_body_id, created_by, constituency_id
on events
for each row
execute function set_events_constituency_id();

