-- Reporters must always read their own submissions (including mla_office_only / anonymous).
-- Others may only read explicitly public rows (not every non-anonymous report).

drop policy if exists "read submissions" on submissions;

create policy "read submissions"
  on submissions for select
  using (
    auth.uid() is not null
    and (
      exists (
        select 1
        from citizens c
        where c.id = submissions.reporter_id
          and c.user_id = auth.uid()
          and c.deleted_at is null
      )
      or (
        deleted_at is null
        and visibility = 'public'
      )
    )
  );

drop policy if exists "read media for submission" on media_attachments;

create policy "read media for submission"
  on media_attachments for select
  using (
    auth.uid() is not null
    and attachable_type = 'submission'
    and exists (
      select 1
      from submissions s
      where s.id = media_attachments.attachable_id
        and (
          exists (
            select 1
            from citizens c
            where c.id = s.reporter_id
              and c.user_id = auth.uid()
              and c.deleted_at is null
          )
          or (
            s.deleted_at is null
            and s.visibility = 'public'
          )
        )
    )
  );
