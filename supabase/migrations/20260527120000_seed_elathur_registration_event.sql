-- Elathur: community registration programme (Malayalam copy + Google Form link).
-- Surfaces in Home → Upcoming Events and Updates → Events (events table only).

do $$
declare
  c_elathur bigint;
begin
  select id into c_elathur from constituencies where name = 'Elathur' limit 1;

  if c_elathur is null then
    raise notice 'Elathur constituency not found — skip event seed';
    return;
  end if;

  if not exists (
    select 1 from events
    where title = 'നമുക്കൊരുമിച്ചു മുന്നേറാം'
      and constituency_id = c_elathur
  ) then
    insert into events (
      title,
      description,
      kind,
      starts_at,
      venue_name,
      constituency_id,
      cover_image_url
    ) values (
      'നമുക്കൊരുമിച്ചു മുന്നേറാം',
      E'ഒന്നൂടെ തുടങ്ങാം…\nവിണ്ണെത്തിപ്പിടിക്കാം…\n\nപ്രതീക്ഷകൾക്ക് ഫുൾ സ്റ്റോപ്പില്ല. കഠിനാധ്വാനവും നിരന്തര പരിശ്രമവും കൊണ്ട് നാം നേടിയെടുക്കും.\n\nനമുക്കൊരുമിച്ചു മുന്നേറാം…\n\nരജിസ്ട്രേഷൻ ലിങ്ക്:\nhttps://forms.gle/EQQbwRFvFsNDJhgs5',
      'general',
      '2026-06-15 10:00:00+05:30',
      'എലത്തൂർ നിയോജകമണ്ഡലം',
      c_elathur,
      'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?w=800&q=80'
    );
  end if;
end $$;
