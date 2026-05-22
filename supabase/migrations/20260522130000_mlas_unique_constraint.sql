-- Ensure only one current MLA per constituency.
-- Partial unique index: unique on constituency_id where is_current = true.
create unique index if not exists idx_mlas_one_current_per_constituency
  on mlas (constituency_id)
  where is_current = true;
