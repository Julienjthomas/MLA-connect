-- Keep posts.like_count in sync with the likes table.

create or replace function sync_post_like_count()
returns trigger language plpgsql security definer as $$
begin
  if (TG_OP = 'INSERT' and NEW.target_type = 'post') then
    update posts set like_count = like_count + 1 where id = NEW.target_id;
  elsif (TG_OP = 'DELETE' and OLD.target_type = 'post') then
    update posts set like_count = greatest(like_count - 1, 0) where id = OLD.target_id;
  end if;
  return null;
end;
$$;

create trigger trg_post_like_count
after insert or delete on likes
for each row execute function sync_post_like_count();
