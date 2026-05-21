create or replace function increment_post_view(post_id bigint)
returns void
language sql
security definer
as $$
  update posts
  set view_count = view_count + 1
  where id = post_id
    and deleted_at is null;
$$;
