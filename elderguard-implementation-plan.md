# ElderGuard — Full Implementation Plan

**Base:** existing `elder_care` Flutter repo (Flutter + Supabase + GetX + Cloudinary already in place)
**Adding:** Google Maps API, AI risk-scoring engine, escalation system, caregiver/institution dashboards
**Purpose of this doc:** single source of truth for module-wise implementation. Once you confirm this, I'll generate one Antigravity prompt per module — each prompt tells Antigravity to scan the current repo structure first, then implement that module without breaking existing code.

**Assumptions I'm making (flag if wrong):**
- You're evolving the existing ElderCare app in place, not starting a new repo.
- Existing auth/profile/task/SOS features stay; new work is additive.
- Risk engine v1 is rule-based (weighted signals), not ML — matches your source doc and is honest for a hackathon demo.
- AI incident summaries use an LLM API call (Gemini or Claude) from a Supabase Edge Function.

---

## 1. Product Vision

ElderGuard is a safety layer, not a generic eldercare app. The core promise: **detect danger even when the senior can't press SOS, verify before alarming anyone, then escalate intelligently.** Every module below exists to serve that loop: observe → score risk → confirm with the senior → escalate → resolve → log.

---

## 2. Tech Stack

| Layer | Tech |
|---|---|
| Client | Flutter (GetX state management) |
| Backend | Supabase (Postgres, Auth, Realtime, Edge Functions, Storage for non-image data) |
| Media storage | Cloudinary (avatars, any incident photo evidence) |
| Maps/Location | Google Maps SDK for Flutter + Geocoding API + geolocator/permission_handler |
| Background work | flutter_background_service, flutter_local_notifications, Supabase Realtime subscriptions |
| Scheduled jobs | Supabase Edge Functions + pg_cron (check-in scheduling, risk scoring, escalation timeouts) |
| AI summary | LLM API call (Gemini/Claude) from an Edge Function, triggered on incident creation |

---

## 3. High-Level Architecture

```
                         ┌────────────────────┐
                         │   Flutter Client    │
                         │  (Senior / Caregiver│
                         │   / Institution UI) │
                         └─────────┬───────────┘
                                   │ Supabase SDK (Auth/DB/Realtime/Storage)
                                   │ Google Maps SDK (client-side maps)
                                   ▼
                         ┌────────────────────┐
                         │     Supabase        │
                         │  Postgres + RLS      │
                         │  Auth                │
                         │  Realtime channels   │
                         │  Storage (docs only) │
                         └─────────┬───────────┘
                                   │
                 ┌─────────────────┼─────────────────┐
                 ▼                 ▼                 ▼
        Edge Function:      Edge Function:     Edge Function:
        risk-engine         escalation-engine  ai-summary
        (pg_cron trigger    (pg_cron trigger   (DB trigger on
        every N min)        checks unresolved  incident insert)
                             incidents)
                 │                 │                 │
                 └─────────────────┴────────┬────────┘
                                             ▼
                                     Push notifications
                                (flutter_local_notifications
                                 + FCM/Supabase Realtime)

        Cloudinary: avatar & incident photo upload (client → Cloudinary
        direct upload, URL stored in Supabase)
```

---

## 4. Module Breakdown

Each module = one future Antigravity prompt. Priority marks suggested build order (P0 = foundation, P1 = core demo feature, P2 = differentiator, P3 = stretch).

### M1 — Senior Profile & Baseline (P0)
- Extend existing profile schema with baseline routine data: wake/sleep time, meal windows, activity periods, medication schedule reference, home location, emergency contacts.
- Screens: senior profile setup/edit, caregiver-view read-only profile.
- This is the reference the risk engine measures against — must exist before any scoring logic.

### M2 — Smart Check-In (P1)
- Scheduled check-in prompts ("Are you safe?" / "Need help" / no response).
- Local notification + in-app prompt; response written to `check_ins` table.
- No-response after timeout feeds the risk engine as a signal.

### M3 — Activity & Signal Logging (P0)
- Lightweight event logger: app opens, manual "I'm active" taps, movement pings from geolocator, check-in responses, medication confirmations — all normalized into `activity_events`.
- This is the substrate every other module reads from.

### M4 — Risk Engine (P1 — the centerpiece)
- Weighted scoring: inactivity duration, missed check-in, missed medication, location anomaly, unusual time-of-day, no response to safety prompt.
- Runs as a Supabase Edge Function on a schedule (e.g. every 10–15 min) per senior, writes to `risk_scores`.
- Bands: 0–30 normal, 31–60 needs attention, 61–80 potential concern, 81–100 critical.
- Must be explainable: store the individual factor contributions, not just the final number.

### M5 — Safety Challenge Flow (P1)
- Triggered when risk crosses a threshold (e.g. ≥60). Push "Are you okay?" to the senior with Yes/Need Help/Call Caregiver/no-response options.
- Response resolves the risk state or confirms escalation is needed.

### M6 — Escalation Engine (P1)
- Escalation tree: senior prompt → primary caregiver → secondary caregiver → institution/emergency contact.
- Each hop has a timeout; unresolved hop auto-advances to next.
- Every step logged to `incident_escalations` for the timeline view.
- Runs as a scheduled Edge Function checking open incidents against elapsed time per hop.

### M7 — Caregiver Dashboard (P1)
- Family/caregiver home screen: list of linked seniors with live status chip (Safe/Monitoring/Concern/Critical), last activity, next check-in.
- Incident detail screen: risk score + explainable factors, last known location, one-tap Call / View Location / Escalate / Mark Safe.

### M8 — Location & Geofencing (P1)
- Google Maps integration: show senior's last known location on a map, home geofence circle, optional named safe zones (park, market).
- Geolocator background pings write to `locations`; geofence breach is a risk signal (M4), not an automatic alarm on its own.

### M9 — Medication as a Signal (P2)
- Reuse/extend existing medication reminder feature so confirmations (or lack thereof) feed the risk engine as one signal among several, not a standalone alert.

### M10 — Vitals as Context (P2, only if vitals already exist in current app)
- Display recent vitals to caregivers as context on the incident screen. Explicitly framed as "context available," never as a diagnosis.

### M11 — AI Incident Summary (P2)
- Edge Function triggered on incident creation: assembles the contributing signals and calls an LLM to generate a one-paragraph natural-language summary for the caregiver notification, instead of a raw alert.

### M12 — Explainable Risk Score UI (P1, pairs with M4)
- Renders the `risk_scores.factors` breakdown as a simple "+25 unusual inactivity / +20 missed check-in / …" list under the score. Pure UI work once M4's data model exists.

### M13 — Safety Timeline (P2)
- Chronological event feed per senior/incident, built from `activity_events` + `check_ins` + `incident_escalations` joined and ordered by timestamp.

### M14 — Safety Circle (P2)
- Multiple contacts per senior with roles (primary, secondary, local contact, institution) and priority order, feeding the escalation tree in M6. Distance-aware notification ordering (nearby contact vs remote) is a nice-to-have refinement here.

### M15 — One-Tap Caregiver Actions (P1, pairs with M7)
- Call / Message / View Location / Mark Safe / Escalate as single-tap actions from the alert notification and incident screen — avoid multi-screen navigation during an emergency.

### M16 — Offline Mode (P3, stretch)
- Queue check-in responses and activity events locally when offline; sync on reconnect. Mostly a resilience story for the demo, doesn't need to be fully bulletproof.

### M17 — Institution Command Center (P3, stretch)
- Admin dashboard for a care facility: aggregate resident counts by status, drill into any resident's incident detail. Reuses M7/M12/M13 components at a different scope (institution → many seniors instead of caregiver → linked seniors).

---

## 5. Database Design (Supabase / Postgres)

Builds on your existing `elder_care` schema — extend rather than replace where tables already exist (profiles, medications, SOS-related tables). New/extended tables below.

```sql
-- Extends existing user/profile table
-- profiles: id (uuid, auth.users fk), role ('senior'|'caregiver'|'institution_admin'),
--           full_name, phone, avatar_url (Cloudinary), created_at

create table senior_profiles (
  id uuid primary key references profiles(id),
  age int,
  home_lat double precision,
  home_lng double precision,
  home_address text,
  wake_time time,
  sleep_time time,
  meal_times jsonb,          -- [{"label":"breakfast","time":"08:00"}, ...]
  activity_periods jsonb,    -- [{"label":"walk","start":"10:00","end":"11:00"}, ...]
  notes text
);

create table caregiver_links (
  id uuid primary key default gen_random_uuid(),
  senior_id uuid references senior_profiles(id),
  caregiver_id uuid references profiles(id),
  relationship text,          -- 'daughter','son','neighbor','institution'
  priority_order int,         -- escalation order
  is_primary boolean default false
);

-- medications: reuse existing table if present; ensure it has senior_id, name,
-- dosage, schedule_times jsonb, active boolean

create table medication_logs (
  id uuid primary key default gen_random_uuid(),
  medication_id uuid references medications(id),
  senior_id uuid references senior_profiles(id),
  scheduled_time timestamptz,
  confirmed_at timestamptz,
  status text                 -- 'pending','confirmed','missed'
);

create table check_ins (
  id uuid primary key default gen_random_uuid(),
  senior_id uuid references senior_profiles(id),
  scheduled_time timestamptz,
  responded_at timestamptz,
  response text,               -- 'safe','need_help','no_response'
  created_at timestamptz default now()
);

create table activity_events (
  id uuid primary key default gen_random_uuid(),
  senior_id uuid references senior_profiles(id),
  event_type text,             -- 'app_open','manual_active','movement','checkin_response','medication_confirm'
  source text,                 -- 'app','background_service','sensor'
  occurred_at timestamptz default now(),
  metadata jsonb
);

create table locations (
  id uuid primary key default gen_random_uuid(),
  senior_id uuid references senior_profiles(id),
  lat double precision,
  lng double precision,
  accuracy_m double precision,
  recorded_at timestamptz default now()
);

create table geofences (
  id uuid primary key default gen_random_uuid(),
  senior_id uuid references senior_profiles(id),
  name text,
  center_lat double precision,
  center_lng double precision,
  radius_m int,
  zone_type text                -- 'home','safe','custom'
);

create table vitals (
  id uuid primary key default gen_random_uuid(),
  senior_id uuid references senior_profiles(id),
  vital_type text,               -- 'heart_rate','bp', etc — only if source data exists
  value jsonb,
  recorded_at timestamptz default now(),
  source text
);

create table risk_scores (
  id uuid primary key default gen_random_uuid(),
  senior_id uuid references senior_profiles(id),
  score int,
  level text,                     -- 'normal','attention','concern','critical'
  factors jsonb,                  -- [{"label":"unusual inactivity","points":25}, ...]
  computed_at timestamptz default now()
);

create table incidents (
  id uuid primary key default gen_random_uuid(),
  senior_id uuid references senior_profiles(id),
  risk_score_id uuid references risk_scores(id),
  status text default 'open',     -- 'open','acknowledged','resolved'
  ai_summary text,
  created_at timestamptz default now(),
  resolved_at timestamptz
);

create table incident_escalations (
  id uuid primary key default gen_random_uuid(),
  incident_id uuid references incidents(id),
  escalation_level int,           -- 0 = senior prompt, 1 = primary, 2 = secondary, ...
  contact_id uuid references profiles(id),
  notified_at timestamptz,
  responded_at timestamptz,
  response text                   -- 'mark_safe','acknowledged','escalate_next'
);

create table notifications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references profiles(id),
  type text,
  payload jsonb,
  read_at timestamptz,
  created_at timestamptz default now()
);

create table institutions (
  id uuid primary key default gen_random_uuid(),
  name text,
  admin_id uuid references profiles(id)
);

create table institution_residents (
  id uuid primary key default gen_random_uuid(),
  institution_id uuid references institutions(id),
  senior_id uuid references senior_profiles(id)
);
```

**RLS pattern:**
- Seniors: full access to their own rows only (`senior_id = auth.uid()` or via `senior_profiles.id`).
- Caregivers: read access to any senior they're linked to via `caregiver_links`; write access limited to escalation responses and marking incidents resolved.
- Institution admins: read access to residents via `institution_residents`.

---

## 6. Risk Engine Design (detail for M4)

```
risk_score =
    w1 * inactivity_minutes_over_baseline
  + w2 * missed_checkin (0/1 flag * weight)
  + w3 * missed_medication (0/1 flag * weight)
  + w4 * location_anomaly (0/1 flag * weight)
  + w5 * unusual_time_of_day (0/1 flag * weight)
  + w6 * no_response_to_prompt (0/1 flag * weight)
```
Store both the final score and each contributing term (for M12's explainability UI). Weights should be tunable constants in one config file/table, not hardcoded per-call, so they can be adjusted without a redeploy.

Bands: 0–30 normal (🟢) / 31–60 needs attention (🟡) / 61–80 potential concern (🟠) / 81–100 critical (🔴). Crossing into 🟠 triggers M5 (safety challenge); crossing into 🔴 or an unanswered M5 prompt triggers M6 (escalation).

---

## 7. Google Maps Integration Points

- Caregiver incident screen: senior's last known location pin + home geofence circle.
- Senior profile setup: pick home location via map (reverse geocoding for address text).
- Optional safe-zone editor: draw/name additional geofences (park, market).
- Distance calculation for Safety Circle (M14) — nearest contact gets notified for local verification.

## 8. Cloudinary Integration Points

- Profile avatars (senior + caregiver) — already in use per existing repo.
- Optional: incident evidence photo if a caregiver/local contact uploads a photo during verification (stretch, only if time allows).

---

## 9. Supabase Edge Functions Needed

| Function | Trigger | Purpose |
|---|---|---|
| `risk-engine` | pg_cron, every 10–15 min | Compute risk score per active senior, write to `risk_scores`, open an incident if threshold crossed |
| `escalation-engine` | pg_cron, every few min | Check open incidents against per-hop timeout, advance escalation level, send notifications |
| `ai-summary` | DB trigger on `incidents` insert | Call LLM API with contributing signals, write `ai_summary` back to the incident |
| `checkin-scheduler` | pg_cron, per senior's configured times | Create a `check_ins` row and push the prompt notification |

---

## 10. Suggested Flutter Folder Structure (additive to existing repo)

```
lib/
  app/
    modules/
      senior_profile/
      check_in/
      risk_dashboard/
      incidents/
      caregiver_dashboard/
      geofencing/
      medication/            # extend existing
      vitals/
      safety_circle/
      institution_dashboard/
    services/
      risk_service.dart
      escalation_service.dart
      maps_service.dart
      cloudinary_service.dart
      notification_service.dart
    data/
      models/
      repositories/
```
(Actual structure to be confirmed once Antigravity scans the current repo — this is the target shape, not a mandate to restructure everything on day one.)

---

## 11. Suggested Build Order

1. **P0** M1 Senior Profile & Baseline, M3 Activity Logging — nothing else works without these.
2. **P1** M4 Risk Engine, M12 Explainable Score UI, M2 Check-In, M5 Safety Challenge, M6 Escalation, M7 Caregiver Dashboard, M8 Maps/Geofencing, M15 One-tap actions — this is the demoable core.
3. **P2** M9 Medication signal, M10 Vitals context, M11 AI Summary, M13 Timeline, M14 Safety Circle — makes the demo feel like a real product.
4. **P3** M16 Offline mode, M17 Institution Command Center — only if time remains.
