-- Add constituency scope to posts so citizen app can filter per constituency.
-- Backfill uses local_body → constituency when present, else author → MLA → constituency.

alter table posts
add column if not exists constituency_id bigint references constituencies(id) on delete set null;

create index if not exists idx_posts_constituency on posts(constituency_id);

-- 1) Backfill from local body when scoped.
update posts p
set constituency_id = lb.constituency_id
from local_bodies lb
where p.constituency_id is null
  and p.local_body_id is not null
  and p.local_body_id = lb.id;

-- 2) Backfill remaining from author → staff → MLA.
update posts p
set constituency_id = m.constituency_id
from mla_staff ms
join mlas m on m.id = ms.mla_id
where p.constituency_id is null
  and p.author_id is not null
  and p.author_id = ms.id;

-- Keep constituency_id populated for new/edited rows.
create or replace function set_posts_constituency_id()
returns trigger
language plpgsql
as $$
declare
  cid bigint;
begin
  -- If explicitly set, keep it.
  if new.constituency_id is not null then
    return new;
  end if;

  -- Derive from local_body if present.
  if new.local_body_id is not null then
    select lb.constituency_id into cid
    from local_bodies lb
    where lb.id = new.local_body_id
    limit 1;
  end if;

  -- Otherwise derive from author → mla.
  if cid is null and new.author_id is not null then
    select m.constituency_id into cid
    from mla_staff ms
    join mlas m on m.id = ms.mla_id
    where ms.id = new.author_id
    limit 1;
  end if;

  new.constituency_id = cid;
  return new;
end;
$$;

drop trigger if exists trg_set_posts_constituency_id on posts;
create trigger trg_set_posts_constituency_id
before insert or update of local_body_id, author_id, constituency_id
on posts
for each row
execute function set_posts_constituency_id();

