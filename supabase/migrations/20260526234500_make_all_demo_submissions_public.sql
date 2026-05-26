-- Force all demo seed submissions to public (Balussery + Elathur).

update submissions
set visibility = 'public', is_anonymous = false
where reference_id in (
  -- Balussery reports
  '7a4b6c4c-1c57-4c1d-bc33-6d7d8f4b9e01',
  'b60a8e2b-9d5d-4bdb-8c2a-5c8d2c3a0a12',
  '2c6d3f88-5c2a-4b8a-9a20-1bd2d8c9e913',
  'e41f9a6d-8b2c-4f1e-a3d0-9c7e5b4a1f02',
  -- Elathur reports + ideas
  'f1a2b3c4-d5e6-4789-f012-3456789abc01',
  'a2b3c4d5-e6f7-4890-a123-456789abcdef',
  'b3c4d5e6-f7a8-4901-b234-56789abcdef0',
  'c4d5e6f7-a8b9-4012-c345-6789abcdef01',
  'd5e6f7a8-b9c0-4123-d456-789abcdef012'
);
