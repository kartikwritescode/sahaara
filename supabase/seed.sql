-- Seed script for local development and Supabase GitHub preview branches
-- Insert sample auth profiles, senior routine, caregiver links, and risk scores

-- Note: Static UUIDs used for repeatable local/preview test data

-- 1. Insert Profiles (Senior & Caregiver)
insert into public.profiles (id, role, full_name, phone, avatar_url)
values
  ('11111111-1111-1111-1111-111111111111', 'senior', 'Robert Smith', '+15550192834', 'https://res.cloudinary.com/demo/image/upload/avatar_senior.jpg'),
  ('22222222-2222-2222-2222-222222222222', 'caregiver', 'Sarah Smith', '+15550982341', 'https://res.cloudinary.com/demo/image/upload/avatar_caregiver.jpg'),
  ('33333333-3333-3333-3333-333333333333', 'caregiver', 'David Smith', '+15550876543', null)
on conflict (id) do nothing;

-- 2. Insert Senior Baseline Routine
insert into public.senior_profiles (id, age, home_lat, home_lng, home_address, wake_time, sleep_time, meal_times, activity_periods, notes)
values
  ('11111111-1111-1111-1111-111111111111', 78, 37.7749, -122.4194, '123 Peace Avenue, Green Park', '07:00:00', '22:00:00',
   '[{"label":"breakfast","time":"08:00"},{"label":"lunch","time":"13:00"},{"label":"dinner","time":"19:00"}]'::jsonb,
   '[{"label":"morning walk","start":"09:00","end":"10:00"}]'::jsonb,
   'Hypertension. Routine walker. Primary contact is Sarah Smith.')
on conflict (id) do nothing;

-- 3. Insert Caregiver Links (Escalation Priority)
insert into public.caregiver_links (senior_id, caregiver_id, relationship, priority_order, is_primary)
values
  ('11111111-1111-1111-1111-111111111111', '22222222-2222-2222-2222-222222222222', 'daughter', 1, true),
  ('11111111-1111-1111-1111-111111111111', '33333333-3333-3333-3333-333333333333', 'son', 2, false);

-- 4. Insert Home Geofence
insert into public.geofences (senior_id, name, center_lat, center_lng, radius_m, zone_type)
values
  ('11111111-1111-1111-1111-111111111111', 'Home Safe Zone', 37.7749, -122.4194, 500, 'home');

-- 5. Insert Medications
insert into public.medications (senior_id, name, dosage, schedule_times, active)
values
  ('11111111-1111-1111-1111-111111111111', 'Aspirin 75mg', '1 Tablet', '["08:00"]'::jsonb, true),
  ('11111111-1111-1111-1111-111111111111', 'Blood Pressure Med', '1 Capsule', '["20:00"]'::jsonb, true);

-- 6. Insert Recent Activity Events
insert into public.activity_events (senior_id, event_type, source, occurred_at)
values
  ('11111111-1111-1111-1111-111111111111', 'app_open', 'app', now() - interval '2 hours'),
  ('11111111-1111-1111-1111-111111111111', 'checkin_response', 'app', now() - interval '1 hour');

-- 7. Insert Initial Risk Score & Incident Demo Data
insert into public.risk_scores (id, senior_id, score, level, factors, computed_at)
values
  ('44444444-4444-4444-4444-444444444444', '11111111-1111-1111-1111-111111111111', 75, 'concern',
   '[{"label":"Unusual inactivity during active window","points":40},{"label":"Missed medication window","points":35}]'::jsonb,
   now())
on conflict (id) do nothing;

insert into public.incidents (senior_id, risk_score_id, status, ai_summary, created_at)
values
-- 8. Insert Vitals Context Data
insert into public.vitals (senior_id, vital_type, value, recorded_at, source)
values
  ('11111111-1111-1111-1111-111111111111', 'heart_rate', '{"bpm": 74}'::jsonb, now() - interval '12 minutes', 'wearable'),
  ('11111111-1111-1111-1111-111111111111', 'bp', '{"systolic": 128, "diastolic": 82}'::jsonb, now() - interval '45 minutes', 'blood_pressure_cuff'),
  ('11111111-1111-1111-1111-111111111111', 'spo2', '{"percentage": 98}'::jsonb, now() - interval '15 minutes', 'pulse_oximeter');
