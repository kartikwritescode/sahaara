import 'package:get/get.dart';
import 'app_routes.dart';

import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/auth_view.dart';
import '../modules/senior_profile/bindings/senior_profile_binding.dart';
import '../modules/senior_profile/views/senior_profile_view.dart';
import '../modules/activity_log/bindings/activity_log_binding.dart';
import '../modules/activity_log/views/activity_log_view.dart';
import '../modules/check_in/bindings/check_in_binding.dart';
import '../modules/check_in/views/check_in_view.dart';
import '../modules/risk_dashboard/bindings/risk_binding.dart';
import '../modules/risk_dashboard/views/risk_dashboard_view.dart';
import '../modules/incidents/bindings/incident_binding.dart';
import '../modules/incidents/views/incidents_view.dart';
import '../modules/caregiver_dashboard/bindings/caregiver_binding.dart';
import '../modules/caregiver_dashboard/views/caregiver_dashboard_view.dart';
import '../modules/geofencing/bindings/geofence_binding.dart';
import '../modules/geofencing/views/geofencing_view.dart';
import '../modules/medication/bindings/medication_binding.dart';
import '../modules/medication/views/medication_view.dart';
import '../modules/safety_circle/bindings/safety_circle_binding.dart';
import '../modules/safety_circle/views/safety_circle_view.dart';
import '../modules/institution_dashboard/bindings/institution_binding.dart';
import '../modules/institution_dashboard/views/institution_dashboard_view.dart';

class AppPages {
  static const INITIAL = Routes.AUTH;

  static final routes = [
    GetPage(
      name: Routes.AUTH,
      page: () => AuthView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.SENIOR_PROFILE,
      page: () => const SeniorProfileView(),
      binding: SeniorProfileBinding(),
    ),
    GetPage(
      name: Routes.ACTIVITY_LOG,
      page: () => const ActivityLogView(),
      binding: ActivityLogBinding(),
    ),
    GetPage(
      name: Routes.CHECK_IN,
      page: () => const CheckInView(),
      binding: CheckInBinding(),
    ),
    GetPage(
      name: Routes.RISK_DASHBOARD,
      page: () => const RiskDashboardView(),
      binding: RiskBinding(),
    ),
    GetPage(
      name: Routes.INCIDENTS,
      page: () => const IncidentsView(),
      binding: IncidentBinding(),
    ),
    GetPage(
      name: Routes.CAREGIVER_DASHBOARD,
      page: () => const CaregiverDashboardView(),
      binding: CaregiverBinding(),
    ),
    GetPage(
      name: Routes.GEOFENCING,
      page: () => const GeofencingView(),
      binding: GeofenceBinding(),
    ),
    GetPage(
      name: Routes.MEDICATION,
      page: () => const MedicationView(),
      binding: MedicationBinding(),
    ),
    GetPage(
      name: Routes.SAFETY_CIRCLE,
      page: () => const SafetyCircleView(),
      binding: SafetyCircleBinding(),
    ),
    GetPage(
      name: Routes.INSTITUTION_DASHBOARD,
      page: () => const InstitutionDashboardView(),
      binding: InstitutionBinding(),
    ),
  ];
}
