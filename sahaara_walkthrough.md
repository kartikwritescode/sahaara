# Walkthrough — Sahaara (ElderGuard) Setup & Implementation

We have fully set up and implemented the foundational architecture, database schema, Edge Functions, and GetX modules for **Sahaara (ElderGuard)**.

---

## 🛠 What Was Accomplished

### 1. Project Dependencies & Config (`pubspec.yaml` & `.env`)
- Added state management (`get`), database (`supabase_flutter`), location (`google_maps_flutter`, `geolocator`, `geocoding`), notifications (`flutter_local_notifications`), media (`cloudinary_public`, `image_picker`), and utilities (`flutter_dotenv`, `intl`, `uuid`, `logger`).
- Configured root `.env` loading and added native Android permissions (`ACCESS_FINE_LOCATION`, `POST_NOTIFICATIONS`, Maps API key).

### 2. Database Schema & Row Level Security (RLS)
- Created `supabase/migrations/0001_init.sql` containing full schemas for `profiles`, `senior_profiles`, `caregiver_links`, `medications`, `medication_logs`, `check_ins`, `activity_events`, `locations`, `geofences`, `vitals`, `risk_scores`, `incidents`, `incident_escalations`, `notifications`, `institutions`, and `institution_residents`.
- Created `supabase/migrations/0002_rls.sql` enforcing row-level security for Seniors, Caregivers, and Facility Admins.

### 3. Supabase Edge Functions
- `risk-engine`: Weighted risk score calculator per senior.
- `escalation-engine`: Monitors open incidents against timeouts and advances escalation level.
- `checkin-scheduler`: Generates scheduled check-in prompts.
- `ai-summary`: Calls Gemini LLM to generate concise incident summaries for caregiver notifications.
- Created `supabase/README.md` with CLI deployment instructions.

### 4. GetX Modular Architecture (`lib/`)
- **Core**: `env`, `app_colors`, `risk_band_helper`, `risk_status_chip`.
- **Services**: `SupabaseService`, `MapsService`, `CloudinaryService`, `NotificationService`, `RiskCalcService`.
- **Models**: Plain Dart models matching DB tables.
- **Routes**: Centralized route table (`app_pages.dart` & `app_routes.dart`).
- **Feature Modules**:
  - `auth` (M0): Role-based sign-in & sign-up.
  - `senior_profile` (M1): Baseline routine, wake/sleep windows, home location setup.
  - `activity_log` (M3): Signal logger for app opens, manual taps, and movement.
  - `check_in` (M2): Smart check-in prompt and response capture.
  - `risk_dashboard` (M4/M12): Risk gauge and explainable factor breakdown list.
  - `incidents` (M5/M6/M11/M15): Escalation tree, AI summary card, and one-tap caregiver actions.
  - `caregiver_dashboard` (M7): Linked seniors list with live status chips.
  - `geofencing` (M8): Google Maps view with home geofence circle and senior location pin.
  - `medication` (M9): Medication reminders feeding risk engine.
  - `safety_circle` (M14): Priority escalation contact tree.
  - `institution_dashboard` (M17): Resident aggregate command center.

---

## 📁 Key File Structure Created

```
supabase/
  migrations/
    0001_init.sql
    0002_rls.sql
  functions/
    risk-engine/index.ts
    escalation-engine/index.ts
    checkin-scheduler/index.ts
    ai-summary/index.ts
  README.md
lib/
  main.dart
  main_binding.dart
  app/
    core/
      constants/app_colors.dart
      env/env.dart
      utils/risk_band_helper.dart
      widgets/risk_status_chip.dart
    data/
      models/
      services/
    routes/
      app_pages.dart
      app_routes.dart
    modules/
      auth/
      senior_profile/
      activity_log/
      check_in/
      risk_dashboard/
      incidents/
      caregiver_dashboard/
      geofencing/
      medication/
      safety_circle/
      institution_dashboard/
```

---

## ⚡ Next Steps for You

1. Populate your keys inside `.env` (`SUPABASE_URL`, `SUPABASE_ANON_KEY`, `GOOGLE_MAPS_API_KEY`, `CLOUDINARY_CLOUD_NAME`, `CLOUDINARY_UPLOAD_PRESET`).
2. Run the SQL migration scripts in your Supabase SQL Editor (`0001_init.sql` and `0002_rls.sql`).
3. Launch the app using `flutter run` on your device or emulator!
