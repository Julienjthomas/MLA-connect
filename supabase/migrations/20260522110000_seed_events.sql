-- Seed sample upcoming events into the posts table.
-- category 'event' maps to UpdateCategory.events in the app.

insert into posts (title, body, category, published_at, is_pinned, priority, author_name, cover_image_url)
values
  (
    'Public Grievance Hearing',
    'Citizens are invited to present their grievances directly to the MLA. Venue: Town Hall, Kodanchery.',
    'event',
    '2026-06-05 10:00:00+05:30',
    false,
    'normal',
    'MLA Office',
    'https://images.unsplash.com/photo-1577563908411-5077b6dc7624?w=800&q=80'
  ),
  (
    'Constituency Meet & Greet',
    'An open session for residents to interact with the MLA and raise local development concerns. Venue: Community Centre, Chelari.',
    'event',
    '2026-06-12 09:00:00+05:30',
    false,
    'normal',
    'MLA Office',
    'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?w=800&q=80'
  ),
  (
    'Ward Development Review',
    'Review of ongoing ward-level infrastructure projects. Attendance open to all ward members. Venue: Municipal Office.',
    'event',
    '2026-06-19 11:00:00+05:30',
    false,
    'normal',
    'MLA Office',
    'https://images.unsplash.com/photo-1503387762-592deb58ef4e?w=800&q=80'
  ),
  (
    'Health Camp — Free Checkup',
    'Free general health checkup camp for all residents. Medicines provided at no cost. Venue: Govt. HSS Kodanchery.',
    'event',
    '2026-06-22 08:00:00+05:30',
    false,
    'normal',
    'MLA Office',
    'https://images.unsplash.com/photo-1584982751601-97ddc0e5ca31?w=800&q=80'
  ),
  (
    'Youth Skill Development Workshop',
    'Vocational training and skill development session for youth aged 18–30. Registration at the MLA office. Venue: ITI Hall.',
    'event',
    '2026-06-28 10:00:00+05:30',
    false,
    'normal',
    'MLA Office',
    'https://images.unsplash.com/photo-1524178232363-1fb2b075b655?w=800&q=80'
  );
