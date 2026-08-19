-- 0002_rls.sql — Sahaara Row Level Security (RLS) Policies

-- Enable RLS on all tables
alter table public.profiles enable row level security;
alter table public.senior_profiles enable row level security;
alter table public.caregiver_links enable row level security;
alter table public.medications enable row level security;
alter table public.medication_logs enable row level security;
alter table public.check_ins enable row level security;
alter table public.activity_events enable row level security;
alter table public.locations enable row level security;
alter table public.geofences enable row level security;
alter table public.vitals enable row level security;
alter table public.risk_scores enable row level security;
alter table public.incidents enable row level security;
alter table public.incident_escalations enable row level security;
alter table public.notifications enable row level security;
alter table public.institutions enable row level security;
alter table public.institution_residents enable row level security;

-- PROFILES POLICIES
create policy "Users can view own profile or linked profiles"
  on public.profiles for select
  using (
    auth.uid() = id
    or exists (
      select 1 from public.caregiver_links
      where (caregiver_id = auth.uid() and senior_id = profiles.id)
         or (senior_id = auth.uid() and caregiver_id = profiles.id)
    )
  );

create policy "Users can insert/update their own profile"
  on public.profiles for all
  using (auth.uid() = id);

-- SENIOR PROFILES POLICIES
create policy "Seniors manage own profile, linked caregivers view"
  on public.senior_profiles for all
  using (
    auth.uid() = id
    or exists (
      select 1 from public.caregiver_links
      where caregiver_id = auth.uid() and senior_id = senior_profiles.id
    )
  );

-- CAREGIVER LINKS POLICIES
create policy "Users view links they belong to"
  on public.caregiver_links for select
  using (senior_id = auth.uid() or caregiver_id = auth.uid());

create policy "Seniors can manage caregiver links"
  on public.caregiver_links for all
  using (senior_id = auth.uid());

-- SENIOR DATA TABLES (check_ins, activity_events, locations, geofences, vitals, risk_scores)
create policy "Senior data access policy"
  on public.check_ins for all
  using (
    senior_id = auth.uid()
    or exists (
      select 1 from public.caregiver_links
      where caregiver_id = auth.uid() and senior_id = check_ins.senior_id
    )
  );

create policy "Activity events access policy"
  on public.activity_events for all
  using (
    senior_id = auth.uid()
    or exists (
      select 1 from public.caregiver_links
      where caregiver_id = auth.uid() and senior_id = activity_events.senior_id
    )
  );

create policy "Locations access policy"
  on public.locations for all
  using (
    senior_id = auth.uid()
    or exists (
      select 1 from public.caregiver_links
      where caregiver_id = auth.uid() and senior_id = locations.senior_id
    )
  );

create policy "Geofences access policy"
  on public.geofences for all
  using (
    senior_id = auth.uid()
    or exists (
      select 1 from public.caregiver_links
      where caregiver_id = auth.uid() and senior_id = geofences.senior_id
    )
  );

create policy "Risk scores access policy"
  on public.risk_scores for all
  using (
    senior_id = auth.uid()
    or exists (
      select 1 from public.caregiver_links
      where caregiver_id = auth.uid() and senior_id = risk_scores.senior_id
    )
  );

-- INCIDENTS & ESCALATIONS POLICIES
create policy "Incidents access policy"
  on public.incidents for all
  using (
    senior_id = auth.uid()
    or exists (
      select 1 from public.caregiver_links
      where caregiver_id = auth.uid() and senior_id = incidents.senior_id
    )
  );

create policy "Incident escalations access policy"
  on public.incident_escalations for all
  using (
    contact_id = auth.uid()
    or exists (
      select 1 from public.incidents i
      join public.caregiver_links cl on i.senior_id = cl.senior_id
      where i.id = incident_escalations.incident_id and (cl.caregiver_id = auth.uid() or cl.senior_id = auth.uid())
    )
  );

-- NOTIFICATIONS POLICY
create policy "Notifications user policy"
  on public.notifications for all
  using (user_id = auth.uid());
