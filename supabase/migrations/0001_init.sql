-- 0001_init.sql — Sahaara Database Schema

-- Profiles Table (Extends auth.users)
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  role text not null check (role in ('senior', 'caregiver', 'institution_admin')),
  full_name text not null,
  phone text,
  avatar_url text,
  created_at timestamptz default now()
);

-- Senior Profiles Table
create table if not exists public.senior_profiles (
  id uuid primary key references public.profiles(id) on delete cascade,
  age int,
  home_lat double precision,
  home_lng double precision,
  home_address text,
  wake_time time,
  sleep_time time,
  meal_times jsonb default '[]'::jsonb,          -- [{"label":"breakfast","time":"08:00"}]
  activity_periods jsonb default '[]'::jsonb,    -- [{"label":"walk","start":"10:00","end":"11:00"}]
  notes text
);

-- Caregiver Links Table
create table if not exists public.caregiver_links (
  id uuid primary key default gen_random_uuid(),
  senior_id uuid not null references public.senior_profiles(id) on delete cascade,
  caregiver_id uuid not null references public.profiles(id) on delete cascade,
  relationship text,                             -- e.g. 'daughter', 'son', 'neighbor'
  priority_order int default 1,                  -- Escalation order
  is_primary boolean default false,
  created_at timestamptz default now()
);

-- Medications Table
create table if not exists public.medications (
  id uuid primary key default gen_random_uuid(),
  senior_id uuid not null references public.senior_profiles(id) on delete cascade,
  name text not null,
  dosage text,
  schedule_times jsonb default '[]'::jsonb,       -- ["08:00", "20:00"]
  active boolean default true,
  created_at timestamptz default now()
);

-- Medication Logs Table
create table if not exists public.medication_logs (
  id uuid primary key default gen_random_uuid(),
  medication_id uuid references public.medications(id) on delete set null,
  senior_id uuid not null references public.senior_profiles(id) on delete cascade,
  scheduled_time timestamptz not null,
  confirmed_at timestamptz,
  status text default 'pending' check (status in ('pending', 'confirmed', 'missed'))
);

-- Check-ins Table
create table if not exists public.check_ins (
  id uuid primary key default gen_random_uuid(),
  senior_id uuid not null references public.senior_profiles(id) on delete cascade,
  scheduled_time timestamptz not null,
  responded_at timestamptz,
  response text check (response in ('safe', 'need_help', 'no_response')),
  created_at timestamptz default now()
);

-- Activity Events Table
create table if not exists public.activity_events (
  id uuid primary key default gen_random_uuid(),
  senior_id uuid not null references public.senior_profiles(id) on delete cascade,
  event_type text not null,                      -- 'app_open','manual_active','movement','checkin_response','medication_confirm'
  source text not null default 'app',             -- 'app','background_service','sensor'
  occurred_at timestamptz default now(),
  metadata jsonb default '{}'::jsonb
);

-- Locations Table
create table if not exists public.locations (
  id uuid primary key default gen_random_uuid(),
  senior_id uuid not null references public.senior_profiles(id) on delete cascade,
  lat double precision not null,
  lng double precision not null,
  accuracy_m double precision,
  recorded_at timestamptz default now()
);

-- Geofences Table
create table if not exists public.geofences (
  id uuid primary key default gen_random_uuid(),
  senior_id uuid not null references public.senior_profiles(id) on delete cascade,
  name text not null,
  center_lat double precision not null,
  center_lng double precision not null,
  radius_m int not null default 500,
  zone_type text default 'home' check (zone_type in ('home', 'safe', 'custom'))
);

-- Vitals Table (Contextual Data)
create table if not exists public.vitals (
  id uuid primary key default gen_random_uuid(),
  senior_id uuid not null references public.senior_profiles(id) on delete cascade,
  vital_type text not null,                      -- 'heart_rate', 'bp', 'spO2'
  value jsonb not null,
  recorded_at timestamptz default now(),
  source text default 'wearable'
);

-- Risk Scores Table (Calculated by Risk Engine)
create table if not exists public.risk_scores (
  id uuid primary key default gen_random_uuid(),
  senior_id uuid not null references public.senior_profiles(id) on delete cascade,
  score int not null check (score >= 0 and score <= 100),
  level text not null check (level in ('normal', 'attention', 'concern', 'critical')),
  factors jsonb not null default '[]'::jsonb,     -- [{"label":"unusual inactivity","points":25}]
  computed_at timestamptz default now()
);

-- Incidents Table
create table if not exists public.incidents (
  id uuid primary key default gen_random_uuid(),
  senior_id uuid not null references public.senior_profiles(id) on delete cascade,
  risk_score_id uuid references public.risk_scores(id) on delete set null,
  status text not null default 'open' check (status in ('open', 'acknowledged', 'resolved')),
  ai_summary text,
  created_at timestamptz default now(),
  resolved_at timestamptz
);

-- Incident Escalations Table
create table if not exists public.incident_escalations (
  id uuid primary key default gen_random_uuid(),
  incident_id uuid not null references public.incidents(id) on delete cascade,
  escalation_level int not null default 0,        -- 0 = senior prompt, 1 = primary, 2 = secondary...
  contact_id uuid references public.profiles(id) on delete set null,
  notified_at timestamptz default now(),
  responded_at timestamptz,
  response text check (response in ('mark_safe', 'acknowledged', 'escalate_next'))
);

-- Notifications Table
create table if not exists public.notifications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  type text not null,
  payload jsonb default '{}'::jsonb,
  read_at timestamptz,
  created_at timestamptz default now()
);

-- Institutions Table
create table if not exists public.institutions (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  admin_id uuid not null references public.profiles(id) on delete cascade
);

-- Institution Residents Table
create table if not exists public.institution_residents (
  id uuid primary key default gen_random_uuid(),
  institution_id uuid not null references public.institutions(id) on delete cascade,
  senior_id uuid not null references public.senior_profiles(id) on delete cascade
);
