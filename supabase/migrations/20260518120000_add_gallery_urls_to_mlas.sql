-- Add photo gallery field to mlas for MLA profile gallery section.
alter table mlas
  add column if not exists gallery_urls jsonb not null default '[]'::jsonb;
