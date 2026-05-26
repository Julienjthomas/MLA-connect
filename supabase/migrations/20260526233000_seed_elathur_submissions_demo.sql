-- Elathur demo submissions: attach to a citizen registered in Elathur constituency.
-- Picks the most recently created Elathur citizen. Idempotent via reference_id.

do $$
declare
  c_elathur   bigint;
  reporter    bigint;
  lb_purak    bigint;
  lb_thalak   bigint;
begin
  select id into c_elathur from constituencies where name = 'Elathur' limit 1;

  if c_elathur is not null then
    insert into local_bodies (constituency_id, name, type, is_active)
    select c_elathur, 'Purakkattiri', 'panchayat', true
    where not exists (
      select 1 from local_bodies lb
      where lb.name = 'Purakkattiri' and lb.constituency_id = c_elathur
    );
  end if;

  if c_elathur is null then
    return;
  end if;

  select c.id
  into reporter
  from citizens c
  where c.deleted_at is null
    and c.constituency_id = c_elathur
  order by c.created_at desc, c.id desc
  limit 1;

  if reporter is null then
    raise notice 'No citizen found for Elathur constituency — create/login with Elathur selected, then re-run.';
    return;
  end if;

  select id into lb_purak from local_bodies lb
  where lb.name = 'Purakkattiri' and (c_elathur is null or lb.constituency_id = c_elathur)
  limit 1;

  select id into lb_thalak from local_bodies lb
  where lb.name = 'Thalakkulathur' and (c_elathur is null or lb.constituency_id = c_elathur)
  limit 1;

  -- 1) Purakkattiri Ward 2 internal road (public report)
  insert into submissions (
    reporter_id, kind, reference_id, category, title, description,
    pin_address, local_body_id, visibility, is_anonymous, status
  )
  select
    reporter, 'report', 'f1a2b3c4-d5e6-4789-f012-3456789abc01', 'road',
    'പുരക്കാട്ടിരി 2 വാർഡ് ഉൾറോഡ്',
    'പുരക്കാട്ടിരി ഗ്രാമപഞ്ചായത്തിലെ 2 വാർഡിലെ ഏകദേശം 1 കി.മീ ഉൾറോഡ് കഴിഞ്ഞ രണ്ടു വർഷമായി പൂർണ്ണമായും തകർന്ന് തരിപ്പണമായി കിടക്കുന്നു. ടാറിങ് ഇളകിമാറി വലിയ കുഴികൾ രൂപപ്പെട്ടിരിക്കുന്നു. ഇരുനൂറോളം കുടുംബങ്ങൾ നിത്യേന യാത്രയ്ക്കായി ആശ്രയിക്കുന്ന ഈ റോഡാണ്. പ്രായമായവർ, രോഗികൾ, ഗർഭിണികൾ, സ്കൂൾ കുട്ടികൾ ഏറ്റവും കഷ്ടപ്പെടുന്നു. ഓട്ടോയും അടിയന്തര വാഹനങ്ങളും വരാൻ മടിക്കുന്നു. മഴക്കാലത്ത് വെള്ളം കെട്ടി കാൽനടയാത്ര അസാധ്യമാകുന്നു. MLA Fund അല്ലെങ്കിൽ മറ്റ് പദ്ധതികളിൽ നിന്ന് റോഡ് അടിയന്തരമായി പുനർനിർമ്മിക്കണമെന്ന് അപേക്ഷിക്കുന്നു.',
    'Purakkattiri Panchayat, Ward 2',
    lb_purak, 'public', false, 'submitted'
  where not exists (
    select 1 from submissions s where s.reference_id = 'f1a2b3c4-d5e6-4789-f012-3456789abc01'
  );

  -- 2) Thalakkulathur HSS — drug activity near school (public report)
  insert into submissions (
    reporter_id, kind, reference_id, category, title, description,
    pin_address, local_body_id, visibility, is_anonymous, status
  )
  select
    reporter, 'report', 'a2b3c4d5-e6f7-4890-a123-456789abcdef', 'safety',
    'തലക്കുളത്തൂർ HSS — ലഹരി മാഫിയ',
    'തലക്കുളത്തൂർ ഹയർ സെക്കൻഡറി സ്കൂൾ പരിസരങ്ങളിലും വിദ്യാർത്ഥികൾ പോകുന്ന വഴികളിലും ലഹരി മാഫിയ പ്രവർത്തനം വർദ്ധിച്ചുവരുന്നു. അപരിചിതർ സ്കൂൾ സമയങ്ങളിലും വൈകുന്നേരങ്ങളിലും ലഹരി വിൽപ്പന/കൈമാറ്റം നടത്തുന്നു. വിദ്യാർത്ഥി സുരക്ഷയ്ക്ക് ഭീഷണി. അപേക്ഷിക്കുന്ന നടപടികൾ: പൊലീസ്/എക്സൈസ് നിരന്തര പട്രോളിങ്; സ്കൂൾ ജംഗ്ഷനുകളിൽ CCTV; ലഹരി വിരുദ്ധ ജാഗ്രതാ സമിതികൾ ശക്തമാക്കൽ.',
    'Thalakkulathur Higher Secondary School',
    lb_thalak, 'public', false, 'submitted'
  where not exists (
    select 1 from submissions s where s.reference_id = 'a2b3c4d5-e6f7-4890-a123-456789abcdef'
  );

  -- 3) Youth Civic Fellowship (public idea)
  insert into submissions (
    reporter_id, kind, reference_id, topic, title, description, benefits,
    beneficiaries, visibility, is_anonymous,
    allow_community_discussion, allow_mla_office_contact, status
  )
  select
    reporter, 'idea', 'b3c4d5e6-f7a8-4901-b234-56789abcdef0',
    'Education',
    'Elathur Youth Civic Fellowship (EYCF)',
    'Vision: Create a new generation of socially responsible, skilled youth who participate in Elathur''s development and governance—bridging citizens, youth, and public administration.

Suggested names: Elathur Youth Civic Fellowship, Future Leaders of Elathur, Janakeeya Youth Fellowship.

Objectives: leadership & governance training; youth input on waste, education, traffic, environment, technology, health; volunteer network for disaster response, health camps, surveys; direct exposure to MLA office, panchayats, departments, NGOs.

Structure: 3/6/12-month tracks—Governance, Technology & Innovation, Social Impact, Education & Career. Ages 18–30. Activities: ward problem mapping, citizen surveys, monthly innovation challenges, MLA interaction sessions, field visits. Digital portal for applications, project tracking, certificates.',
    'Stronger youth leadership, better constituency problem reporting, and a scalable volunteer ecosystem across Elathur.',
    array['Youth', 'Students', 'Residents'],
    'public', false, true, true, 'submitted'
  where not exists (
    select 1 from submissions s where s.reference_id = 'b3c4d5e6-f7a8-4901-b234-56789abcdef0'
  );

  -- 4) Coastal Destination Hub (public idea)
  insert into submissions (
    reporter_id, kind, reference_id, topic, title, description, benefits,
    beneficiaries, visibility, is_anonymous,
    allow_community_discussion, allow_mla_office_contact, status
  )
  select
    reporter, 'idea', 'c4d5e6f7-a8b9-4012-c345-6789abcdef01',
    'Tourism',
    'Elathur Coastal Destination Hub',
    'Vision: Transform selected coastal areas of Elathur into a sustainable, culturally rich destination for small destination weddings, family gatherings, cultural events, and eco-tourism—not luxury commercialization but planned coastal experiences that create local employment while preserving nature.

Core concept: Coastal Event & Cultural Zone with modular beachside venues, sunset walkway, local food/handicraft stalls (women entrepreneurs, fisher families), and cultural performance arena.

Eco approach: minimal permanent concrete, waste segregation, plastic-free zones, solar lighting, mangrove protection.

Economic impact: event management, catering, homestays, transport, photography. Pilot Phase 1: one small beachside zone, weekend tourism, monitor environment and revenue.',
    'Local employment, tourism branding as North Kerala''s affordable eco-destination, and recurring cultural festivals.',
    array['Residents', 'Business Owners', 'Youth'],
    'public', false, true, true, 'submitted'
  where not exists (
    select 1 from submissions s where s.reference_id = 'c4d5e6f7-a8b9-4012-c345-6789abcdef01'
  );

  -- 5) Vengalam Underbridge Sports Hub (public idea)
  insert into submissions (
    reporter_id, kind, reference_id, topic, title, description, benefits,
    beneficiaries, visibility, is_anonymous,
    allow_community_discussion, allow_mla_office_contact, status
  )
  select
    reporter, 'idea', 'd5e6f7a8-b9c0-4123-d456-789abcdef012',
    'Infrastructure',
    'Vengalam Underbridge Sports & Youth Hub',
    'Vision: Convert unused space under flyovers/overbridges near Vengalam into a multi-purpose Sports, Fitness & Youth Activity Hub for Elathur—indoor sports, recreation, fitness, cultural activities, and safe community gathering instead of dumping grounds.

Why: utilizes dead public space with low land cost; addresses lack of affordable indoor sports for youth.

Components: modular courts (badminton, futsal, volleyball, table tennis, basketball practice, skating); open gym and senior fitness corner; lighting and safety for evening use.

Model: landmark PPP-style development—public infrastructure + local operators for events and cafés.',
    'Safe youth recreation, reduced anti-social use of underbridge spaces, and year-round sports access.',
    array['Youth', 'Residents', 'Students'],
    'public', false, true, true, 'submitted'
  where not exists (
    select 1 from submissions s where s.reference_id = 'd5e6f7a8-b9c0-4123-d456-789abcdef012'
  );

  -- Keep ownership and public visibility when migration is re-applied.
  update submissions
  set reporter_id = reporter, visibility = 'public', is_anonymous = false
  where reference_id in (
    'f1a2b3c4-d5e6-4789-f012-3456789abc01',
    'a2b3c4d5-e6f7-4890-a123-456789abcdef',
    'b3c4d5e6-f7a8-4901-b234-56789abcdef0',
    'c4d5e6f7-a8b9-4012-c345-6789abcdef01',
    'd5e6f7a8-b9c0-4123-d456-789abcdef012'
  );
end $$;
