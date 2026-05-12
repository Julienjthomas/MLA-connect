-- citizens.constituency_id must match constituencies.id type.
-- Many projects use bigint for constituencies.id; this migration supports that.
-- If a previous attempt added uuid, drop it (no FK was applied). Re-run whole file.

do $$
begin
  if exists (
    select 1
    from information_schema.columns c
    where c.table_schema = 'public'
      and c.table_name = 'citizens'
      and c.column_name = 'constituency_id'
      and c.data_type = 'uuid'
  ) then
    alter table public.citizens drop column constituency_id;
  end if;
end $$;

alter table public.citizens
  add column if not exists constituency_id bigint;

create index if not exists idx_citizens_constituency on public.citizens (constituency_id);

do $$
begin
  if not exists (
    select 1
    from information_schema.table_constraints tc
    join information_schema.key_column_usage kcu
      on tc.constraint_schema = kcu.constraint_schema
     and tc.constraint_name = kcu.constraint_name
    where tc.table_schema = 'public'
      and tc.table_name = 'citizens'
      and tc.constraint_type = 'FOREIGN KEY'
      and kcu.column_name = 'constituency_id'
  ) then
    alter table public.citizens
      add constraint citizens_constituency_id_fkey
      foreign key (constituency_id) references public.constituencies (id);
  end if;
end $$;
