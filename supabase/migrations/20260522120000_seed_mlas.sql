-- Seed MLAs for Balussery, Koduvalli, and Perambra constituencies.
-- Idempotent: inserts if no current MLA exists, updates bio/name if row already there with empty bio.

do $$
declare
  c_balussery bigint;
  c_koduvalli bigint;
  c_perambra  bigint;
begin

  select id into c_balussery from constituencies where name = 'Balussery' limit 1;
  select id into c_koduvalli from constituencies where name = 'Koduvalli' limit 1;
  select id into c_perambra  from constituencies where name = 'Perambra'  limit 1;

  -- Balussery: V.T. Sooraj (INC)
  if c_balussery is not null then
    insert into mlas (constituency_id, full_name, term_label, serving_since, bio, is_current)
    values (
      c_balussery,
      'V.T. Sooraj',
      'MLA, Balussery',
      '2026-05-20',
      'V.T. Sooraj of the Indian National Congress is the MLA representing the Balussery constituency since 2026. He began his political career as a KSU (Kerala Students'' Union) school unit president and rose to become a prominent district leader, championing student movements and fighting for the rights of ordinary citizens. Coming from a humble background, his politics are grounded in the everyday struggles of the people he serves.',
      true
    )
    on conflict do nothing;

    update mlas
    set
      full_name    = 'V.T. Sooraj',
      term_label   = 'MLA, Balussery',
      serving_since = '2026-05-20',
      bio          = 'V.T. Sooraj of the Indian National Congress is the MLA representing the Balussery constituency since 2026. He began his political career as a KSU (Kerala Students'' Union) school unit president and rose to become a prominent district leader, championing student movements and fighting for the rights of ordinary citizens. Coming from a humble background, his politics are grounded in the everyday struggles of the people he serves.',
      updated_at   = now()
    where constituency_id = c_balussery and is_current = true and (bio is null or bio = '');
  end if;

  -- Koduvalli: P.K. Firos (IUML)
  if c_koduvalli is not null then
    insert into mlas (constituency_id, full_name, term_label, serving_since, bio, is_current)
    values (
      c_koduvalli,
      'P.K. Firos',
      'MLA, Koduvalli',
      '2026-05-20',
      'P.K. Firos of the Indian Union Muslim League (IUML) is the MLA representing the Koduvalli constituency since 2026, winning by a dominant margin of over 36,000 votes. A firebrand leader of the Muslim Youth League and a legal consultant by profession, he holds a Post Graduate LLM degree. He has been a driving force in strengthening the IUML''s presence among the youth of the region.',
      true
    )
    on conflict do nothing;

    update mlas
    set
      full_name    = 'P.K. Firos',
      term_label   = 'MLA, Koduvalli',
      serving_since = '2026-05-20',
      bio          = 'P.K. Firos of the Indian Union Muslim League (IUML) is the MLA representing the Koduvalli constituency since 2026, winning by a dominant margin of over 36,000 votes. A firebrand leader of the Muslim Youth League and a legal consultant by profession, he holds a Post Graduate LLM degree. He has been a driving force in strengthening the IUML''s presence among the youth of the region.',
      updated_at   = now()
    where constituency_id = c_koduvalli and is_current = true and (bio is null or bio = '');
  end if;

  -- Perambra: Adv. Fathima Thahiliya (IUML)
  if c_perambra is not null then
    insert into mlas (constituency_id, full_name, term_label, serving_since, bio, is_current)
    values (
      c_perambra,
      'Adv. Fathima Thahiliya',
      'MLA, Perambra',
      '2026-05-20',
      'Adv. Fathima Thahiliya of the Indian Union Muslim League (IUML) is the MLA representing the Perambra constituency since 2026, making history as the first woman elected to the Kerala Legislative Assembly under the IUML banner. Born on 5 September 1993 in Peruvayal, Kozhikode, she holds a BA LLB from Government Law College, Kozhikode and an LLM from Government Law College, Thrissur. She practises as an advocate at the Kozhikode District Court. She rose through the Muslim Students Federation (MSF) to become national vice-president and was a founding leader of Haritha, the women''s wing of MSF. In 2024 she became the first woman appointed to the state committee of the Muslim Youth League. She won the Perambra seat with 81,429 votes, defeating her nearest rival by a margin of 5,087 votes.',
      true
    )
    on conflict do nothing;

    update mlas
    set
      full_name    = 'Adv. Fathima Thahiliya',
      term_label   = 'MLA, Perambra',
      serving_since = '2026-05-20',
      bio          = 'Adv. Fathima Thahiliya of the Indian Union Muslim League (IUML) is the MLA representing the Perambra constituency since 2026, making history as the first woman elected to the Kerala Legislative Assembly under the IUML banner. Born on 5 September 1993 in Peruvayal, Kozhikode, she holds a BA LLB from Government Law College, Kozhikode and an LLM from Government Law College, Thrissur. She practises as an advocate at the Kozhikode District Court. She rose through the Muslim Students Federation (MSF) to become national vice-president and was a founding leader of Haritha, the women''s wing of MSF. In 2024 she became the first woman appointed to the state committee of the Muslim Youth League. She won the Perambra seat with 81,429 votes, defeating her nearest rival by a margin of 5,087 votes.',
      updated_at   = now()
    where constituency_id = c_perambra and is_current = true and (bio is null or bio = '');
  end if;

end $$;
