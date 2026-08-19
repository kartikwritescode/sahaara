# 🚀 Sahaara (ElderGuard) — Release Documentation

**Version:** `v1.0.0`  
**Build Number:** `1001`  
**Release Date:** August 19, 2026  
**Status:** Stable / Production Candidate  

---

## 📋 Executive Overview

**Sahaara (ElderGuard)** is a real-time safety, risk-scoring, and emergency escalation layer built for elderly care. The platform bridges seniors, family caregivers, and institutional administration through autonomous risk assessment, geofence monitoring, safety check-in scheduling, and direct incident response.

This document details the release specifications, feature set, architecture overview, build configuration, and deployment instructions for **Sahaara v1.0.0**.

---

## ✨ Release Highlights & Included Modules

### 1. 🔐 Role-Based Authentication & User Management (`lib/app/modules/auth`)
* **Multi-Role Support**: Custom onboarding & auth flows for **Seniors (Care Receivers)**, **Caregivers (Family)**, and **Institution Admins**.
* **Pairing & Care Link System**: Unique 6-character Care-IDs for linking seniors with family members and caregivers.
* **Profile Management**: Profile image uploads powered by Cloudinary and role-specific permissions backed by Supabase Row Level Security (RLS).

### 2. 🧮 AI Dynamic Risk Scoring Engine (`lib/app/modules/risk_dashboard`)
* **Weighted Real-Time Calculation**: Dynamic risk scoring algorithm (0–100) aggregating:
  * Vital sign anomalies (Heart rate spikes/drops, low SpO2 levels).
  * Geofence boundary breaches.
  * Unacknowledged safety check-in prompts.
  * Inactivity or lack of motion logs.
* **Risk Banding**:
  * 🟢 **Low Risk (0–29)**: Standard baseline monitoring.
  * 🟡 **Moderate Risk (30–69)**: Caregiver soft alerts and highlighted check-ins.
  * 🔴 **High / Critical Risk (70–100)**: Autonomous escalation trigger.

### 3. 🗺️ Live Geofencing & Google Maps Integration (`lib/app/modules/geofencing`)
* **Custom Safe Zones**: Caregiver-configurable circular geofences with customizable center coordinates and buffer radii.
* **Live GPS Marker Sync**: Real-time senior location updates plotted on Google Maps.
* **Automatic Boundary Breach Alerts**: Immediate escalation trigger upon exiting safe zones.

### 4. ⚡ Autonomous Incident & Escalation System (`lib/app/modules/incidents`)
* **Multi-Tier Emergency Cascade**:
  * **Level 1**: Senior device push notification & audible alert.
  * **Level 2**: Priority push notification dispatched to linked Caregiver devices.
  * **Level 3**: Automated alert to secondary Safety Circle & Emergency Services / Institution Admin.
* **One-Tap Actions**: Quick-action buttons allowing caregivers to "Mark Senior Safe", "Escalate Incident", or navigate directly to live geofence coordinates.

### 5. ⏱️ Automated Check-In & Medication Scheduler (`lib/app/modules/check_in` & `lib/app/modules/medication`)
* **Scheduled Safety Check-Ins**: Periodic response prompts sent to the senior's device.
* **Medication Reminders**: Daily dose schedules with one-tap confirmation logging.

### 6. 📊 Multi-Role Dashboards (`lib/app/modules/caregiver_dashboard` & `lib/app/modules/institution_dashboard`)
* **Senior Mode**: High-contrast, large-button layout featuring an emergency SOS button and simple daily task list.
* **Caregiver Dashboard**: Patient cards displaying real-time risk chips, location status, relationship tags, and direct navigation to incidents.
* **Institution Admin Dashboard**: Multi-patient oversight panel for elder care homes and medical facilities.

---

## 🏗️ Technical Architecture & Stack Specs

| Component | Technology / Library | Version / Constraint |
|---|---|---|
| **Framework** | Flutter | `>=3.19.0` |
| **Language** | Dart | `>=3.10.4` |
| **State & Routing** | GetX | `^4.7.3` |
| **Backend & Auth** | Supabase Flutter | `^2.17.2` |
| **Database Engine** | PostgreSQL (Supabase) | Row Level Security (RLS) Enabled |
| **Maps Engine** | Google Maps Flutter | `^2.18.0` |
| **Location Services** | Geolocator & Geocoding | `geolocator ^14.0.3` / `geocoding ^3.0.0` |
| **Asset Storage** | Cloudinary Public | `^0.23.1` |
| **Notifications** | Flutter Local Notifications | `^22.3.0` |
| **Push Messaging** | Firebase Messaging | `firebase-bom:34.8.0` |

---

## ⚙️ Build & Android Deployment Configuration

### Gradle & Kotlin Build Tooling

```kotlin
// android/settings.gradle.kts
plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.9.1" apply false
    id("org.jetbrains.kotlin.android") version "2.3.10" apply false
    id("com.google.gms.google-services") version "4.4.2" apply false
}
```

```kotlin
// android/app/build.gradle.kts
android {
    namespace = "com.example.sahaara"
    compileSdk = 36

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlin {
        compilerOptions {
            jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_11
        }
    }

    defaultConfig {
        applicationId = "com.example.sahaara"
        minSdk = 26
        targetSdk = 33
    }
}
```

---

## 🔒 Security Posture & Secrets Management

1. **Environment Isolation**:
   - `lib/app/core/env/env.dart` dynamically consumes variables from `.env` with fallback access to `constants.dart`.
   - `android/app/src/main/res/values/secrets.xml` manages the native `google_maps_api_key`.

2. **Git Protection (`.gitignore`)**:
   - All secret files (`secrets.xml`, `constants.dart`, `.env`, `google-services.json`) are strictly excluded from version control.

3. **Supabase Data Isolation**:
   - RLS policies ensure Seniors can only access their own vitals and events.
   - Caregivers can only access seniors linked through verified `care_links` records.

---

## 🧪 Quality Assurance & Verification

* **Static Analysis**: `flutter analyze` completed with **0 Compilation Errors**.
* **Dependency Audit**: Verified compatible version resolution across all native and Dart plugins.
* **Build Verification**: Cleaned Gradle dependency tree and validated Kotlin `2.3.10` DSL compliance.

---

## 🛠️ Deployment Steps (Release APK / Bundle)

To assemble a production release build:

```bash
# 1. Clean build artifacts
flutter clean

# 2. Fetch dependencies
flutter pub get

# 3. Analyze codebase
flutter analyze

# 4. Assemble Release APK
flutter build apk --release

# 5. (Optional) Assemble Android App Bundle (AAB) for Google Play
flutter build appbundle --release
```

---

<div align="center">
  <b>Sahaara (ElderGuard) v1.0.0</b> — Designed & Maintained for Senior Safety
</div>
