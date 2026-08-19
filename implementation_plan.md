# Implementation Plan — Sahaara (ElderGuard)

This implementation plan outlines the architecture, database migrations, Edge Functions, package integrations, and module implementations for **Sahaara (ElderGuard)**.

---

## 1. Manual Action Guide (User Steps Required)

Before or alongside codebase implementation, you need to perform the following setup steps on external service dashboards:

### A. Supabase Setup
1. Log into [Supabase Dashboard](https://supabase.com).
2. Create a new project named `sahaara`.
3. Navigate to **Project Settings -> API** and copy:
   - **Project URL** (`SUPABASE_URL`)
   - **anon / public key** (`SUPABASE_ANON_KEY`)
4. Once we generate `supabase/migrations/0001_init.sql` and `0002_rls.sql`, navigate to **SQL Editor** in your Supabase dashboard, paste the SQL script contents, and click **Run**.
5. (Optional for local CLI dev): Run `supabase db push` or `supabase functions deploy` if using the Supabase CLI.

### B. Google Maps Platform Setup
1. Go to [Google Cloud Console](https://console.cloud.google.com).
2. Create a project (or select an existing one).
3. In **APIs & Services -> Library**, enable:
   - **Maps SDK for Android**
   - **Maps SDK for iOS**
   - **Geocoding API**
4. Go to **APIs & Services -> Credentials**, click **Create Credentials -> API Key**, and copy your `GOOGLE_MAPS_API_KEY`.

### C. Cloudinary Setup
1. Register/log in to [Cloudinary](https://cloudinary.com).
2. Copy your **Cloud Name** (`CLOUDINARY_CLOUD_NAME`) from the Dashboard.
3. Go to **Settings -> Upload**, scroll down to **Upload presets**, click **Add upload preset**:
   - Preset name: e.g., `sahaara_preset`
   - Signing Mode: **Unsigned**
4. Save the preset name (`CLOUDINARY_UPLOAD_PRESET`).

### D. Local Environment Setup
Create a file named `.env` in the root folder of this project:
```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
GOOGLE_MAPS_API_KEY=your-google-maps-key
CLOUDINARY_CLOUD_NAME=your-cloudinary-name
CLOUDINARY_UPLOAD_PRESET=sahaara_preset
```

---

## 2. Proposed Automated Codebase Changes

### Dependencies & Setup
#### [MODIFY] [pubspec.yaml](file:///c:/Users/Kartik/StudioProjects/sahaara/pubspec.yaml)
Add packages: `get`, `supabase_flutter`, `google_maps_flutter`, `geolocator`, `geocoding`, `permission_handler`, `cloudinary_public`, `image_picker`, `flutter_local_notifications`, `flutter_dotenv`, `intl`, `uuid`, `logger`.

#### [NEW] [.env](file:///c:/Users/Kartik/StudioProjects/sahaara/.env)
Environment variables placeholder.

#### [NEW] [assets/](file:///c:/Users/Kartik/StudioProjects/sahaara/assets/)
Register `.env` in `pubspec.yaml` assets section.

---

### Native Configurations

#### [MODIFY] [AndroidManifest.xml](file:///c:/Users/Kartik/StudioProjects/sahaara/android/app/src/main/AndroidManifest.xml)
- Add location permissions (`ACCESS_FINE_LOCATION`, `ACCESS_COARSE_LOCATION`, `ACCESS_BACKGROUND_LOCATION`).
- Add Google Maps API key meta-data tag.

#### [MODIFY] [AppDelegate.swift / Info.plist](file:///c:/Users/Kartik/StudioProjects/sahaara/ios/Runner/Info.plist)
- Add location usage descriptions (`NSLocationWhenInUseUsageDescription`, `NSLocationAlwaysAndWhenInUseUsageDescription`).

---

### Supabase Backend & Database Migrations

#### [NEW] [0001_init.sql](file:///c:/Users/Kartik/StudioProjects/sahaara/supabase/migrations/0001_init.sql)
Creates complete DB schema: `profiles`, `senior_profiles`, `caregiver_links`, `medications`, `medication_logs`, `check_ins`, `activity_events`, `locations`, `geofences`, `vitals`, `risk_scores`, `incidents`, `incident_escalations`, `notifications`, `institutions`, `institution_residents`.

#### [NEW] [0002_rls.sql](file:///c:/Users/Kartik/StudioProjects/sahaara/supabase/migrations/0002_rls.sql)
Row Level Security (RLS) policies for Seniors, Caregivers, and Institutions.

#### [NEW] Edge Functions
- [NEW] `supabase/functions/risk-engine/index.ts`
- [NEW] `supabase/functions/escalation-engine/index.ts`
- [NEW] `supabase/functions/checkin-scheduler/index.ts`
- [NEW] `supabase/functions/ai-summary/index.ts`
- [NEW] `supabase/README.md`

---

### Flutter Core & GetX Architecture Structure

```
lib/
  main.dart
  main_binding.dart
  app/
    core/
      constants/
      env/
      theme/
      utils/
      widgets/
    data/
      models/
      services/ (Supabase, Maps, Cloudinary, Notification, RiskCalc)
    routes/
      app_pages.dart
      app_routes.dart
    modules/
      auth/
      senior_profile/
      check_in/
      activity_log/
      risk_dashboard/
      incidents/
      caregiver_dashboard/
      geofencing/
      medication/
      safety_circle/
      institution_dashboard/
```

---

## 3. Verification Plan

### Automated Tests
- Run `flutter pub get` and check for clean package resolution.
- Run `flutter analyze` to ensure 0 static analysis errors.

### Manual Verification
- Test app launch on Windows/Android emulator.
- Test Supabase initialization via `.env`.
- Test GetX routing and binding initializations.
