-- Add Elathur and Nadapuram constituencies, local bodies, and MLAs.
-- Idempotent: skips rows that already exist by name.

do $$
declare
  c_elathur   bigint;
  c_nadapuram bigint;
begin

  -- ── Constituencies ──────────────────────────────

  select id into c_elathur from constituencies where name = 'Elathur' limit 1;
  if c_elathur is null then
    insert into constituencies (name, state, is_active) values ('Elathur', 'Kerala', true)
    returning id into c_elathur;
  end if;

  select id into c_nadapuram from constituencies where name = 'Nadapuram' limit 1;
  if c_nadapuram is null then
    insert into constituencies (name, state, is_active) values ('Nadapuram', 'Kerala', true)
    returning id into c_nadapuram;
  end if;

  -- ── Local Bodies ────────────────────────────────

  insert into local_bodies (constituency_id, name, type, is_active)
  select c_elathur, v.name, 'panchayat', true
  from (values
    ('Chelannur'), ('Elathur'), ('Kakkodi'), ('Kakkur'),
    ('Kuruvattur'), ('Nanmanda'), ('Thalakkulathur')
  ) as v(name)
  where not exists (
    select 1 from local_bodies lb where lb.name = v.name and lb.constituency_id = c_elathur
  );

  insert into local_bodies (constituency_id, name, type, is_active)
  select c_nadapuram, v.name, 'panchayat', true
  from (values
    ('Vanimel'), ('Edacheri'), ('Thuneri'), ('Chekkiad'), ('Valayam'),
    ('Narippatta'), ('Kayakkodi'), ('Kavilumpara'), ('Maruthonkara'), ('Nadapuram')
  ) as v(name)
  where not exists (
    select 1 from local_bodies lb where lb.name = v.name and lb.constituency_id = c_nadapuram
  );

  -- ── MLAs ────────────────────────────────────────

  -- Elathur: Vidya Balakrishnan (INC)
  if c_elathur is not null then
    insert into mlas (constituency_id, full_name, term_label, serving_since, bio, is_current)
    values (
      c_elathur,
      'Vidya Balakrishnan',
      'MLA, Elathur',
      '2026-05-04',
      'Vidya Balakrishnan (40) of the Indian National Congress is the MLA representing the Elathur constituency in Kozhikode district, Kerala since 2026. A practicing lawyer with a decade-long tenure as a Kozhikode Municipal Corporation councillor, she built her career on advocating for justice and social welfare through grassroots governance and local development. Her legal expertise equips her to address complex policy issues affecting the constituency. She rose to prominence as a Youth Congress leader and prominent face of the National Congress, championing governance improvements and addressing public concerns with a focus on "the things that directly impact the people of my constituency." She won the Elathur seat with a margin of 12,162 votes, unseating the incumbent Forest Minister who had held the seat since 2011.',
      true
    )
    on conflict do nothing;

    update mlas
    set
      full_name     = 'Vidya Balakrishnan',
      term_label    = 'MLA, Elathur',
      serving_since = '2026-05-04',
      bio           = 'Vidya Balakrishnan (40) of the Indian National Congress is the MLA representing the Elathur constituency in Kozhikode district, Kerala since 2026. A practicing lawyer with a decade-long tenure as a Kozhikode Municipal Corporation councillor, she built her career on advocating for justice and social welfare through grassroots governance and local development. Her legal expertise equips her to address complex policy issues affecting the constituency. She rose to prominence as a Youth Congress leader and prominent face of the National Congress, championing governance improvements and addressing public concerns with a focus on "the things that directly impact the people of my constituency." She won the Elathur seat with a margin of 12,162 votes, unseating the incumbent Forest Minister who had held the seat since 2011.',
      updated_at    = now()
    where constituency_id = c_elathur and is_current = true and (bio is null or bio = '');
  end if;

  -- Nadapuram: K.M. Abijith (INC)
  if c_nadapuram is not null then
    insert into mlas (constituency_id, full_name, term_label, serving_since, bio, is_current)
    values (
      c_nadapuram,
      'K.M. Abijith',
      'MLA, Nadapuram',
      '2026-05-04',
      'K.M. Abijith of the Indian National Congress is the MLA representing the Nadapuram constituency since 2026. He won the seat with a decisive margin of 23,600 votes, marking a significant shift in the constituency which had previously been held by the CPI.',
      true
    )
    on conflict do nothing;
  end if;

end $$;
