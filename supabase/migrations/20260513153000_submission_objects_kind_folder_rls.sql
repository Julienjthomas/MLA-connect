-- Citizen pre-submit uploads: problems|ideas|improvements|appreciations/{auth_user_id}/…

create policy "submission_objects_insert_own_kind_folder"
  on storage.objects for insert
  to authenticated
  with check (
    bucket_id = 'submission-objects'
    and (storage.foldername(name))[1] in ('problems', 'ideas', 'improvements', 'appreciations')
    and (storage.foldername(name))[2] = auth.uid()::text
  );

create policy "submission_objects_select_own_kind_folder"
  on storage.objects for select
  to authenticated
  using (
    bucket_id = 'submission-objects'
    and (storage.foldername(name))[1] in ('problems', 'ideas', 'improvements', 'appreciations')
    and (storage.foldername(name))[2] = auth.uid()::text
  );

create policy "submission_objects_update_own_kind_folder"
  on storage.objects for update
  to authenticated
  using (
    bucket_id = 'submission-objects'
    and (storage.foldername(name))[1] in ('problems', 'ideas', 'improvements', 'appreciations')
    and (storage.foldername(name))[2] = auth.uid()::text
  )
  with check (
    bucket_id = 'submission-objects'
    and (storage.foldername(name))[1] in ('problems', 'ideas', 'improvements', 'appreciations')
    and (storage.foldername(name))[2] = auth.uid()::text
  );

create policy "submission_objects_delete_own_kind_folder"
  on storage.objects for delete
  to authenticated
  using (
    bucket_id = 'submission-objects'
    and (storage.foldername(name))[1] in ('problems', 'ideas', 'improvements', 'appreciations')
    and (storage.foldername(name))[2] = auth.uid()::text
  );
