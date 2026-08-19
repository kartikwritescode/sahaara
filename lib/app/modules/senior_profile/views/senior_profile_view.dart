import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/senior_profile_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../routes/app_routes.dart';

class SeniorProfileView extends GetView<SeniorProfileController> {
  const SeniorProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Senior Routine & Profile Baseline'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.dashboard_outlined),
            tooltip: 'Caregiver Dashboard',
            onPressed: () => Get.toNamed(Routes.CAREGIVER_DASHBOARD),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Baseline Routine Baseline (P0)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'This baseline is used by the Sahaara AI Risk Engine to detect anomalies.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Obx(() => ListTile(
                      leading: const Icon(Icons.wb_sunny_outlined, color: Colors.orange),
                      title: const Text('Wake Up Time'),
                      trailing: Text(controller.wakeTime.value, style: const TextStyle(fontWeight: FontWeight.bold)),
                    )),
                    const Divider(),
                    Obx(() => ListTile(
                      leading: const Icon(Icons.bedtime_outlined, color: Colors.indigo),
                      title: const Text('Sleep Time'),
                      trailing: Text(controller.sleepTime.value, style: const TextStyle(fontWeight: FontWeight.bold)),
                    )),
                    const Divider(),
                    Obx(() => ListTile(
                      leading: const Icon(Icons.location_on_outlined, color: Colors.red),
                      title: const Text('Home Address & Geofence'),
                      subtitle: Text(controller.homeAddress.value),
                      trailing: IconButton(
                        icon: const Icon(Icons.my_location),
                        onPressed: controller.updateHomeLocationFromGPS,
                      ),
                    )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    icon: const Icon(Icons.save, color: Colors.white),
                    label: const Text('Save Baseline', style: TextStyle(color: Colors.white)),
                    onPressed: controller.saveProfile,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 12),
            const Text('Module Shortcuts:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ActionChip(
                  avatar: const Icon(Icons.fact_check_outlined, size: 18),
                  label: const Text('Check-Ins (M2)'),
                  onPressed: () => Get.toNamed(Routes.CHECK_IN),
                ),
                ActionChip(
                  avatar: const Icon(Icons.speed, size: 18),
                  label: const Text('Risk Dashboard (M4/M12)'),
                  onPressed: () => Get.toNamed(Routes.RISK_DASHBOARD),
                ),
                ActionChip(
                  avatar: const Icon(Icons.warning_amber, size: 18),
                  label: const Text('Incidents & Escalations (M5/M6)'),
                  onPressed: () => Get.toNamed(Routes.INCIDENTS),
                ),
                ActionChip(
                  avatar: const Icon(Icons.map_outlined, size: 18),
                  label: const Text('Geofencing (M8)'),
                  onPressed: () => Get.toNamed(Routes.GEOFENCING),
                ),
                ActionChip(
                  avatar: const Icon(Icons.medical_services_outlined, size: 18),
                  label: const Text('Medications (M9)'),
                  onPressed: () => Get.toNamed(Routes.MEDICATION),
                ),
                ActionChip(
                  avatar: const Icon(Icons.people_outline, size: 18),
                  label: const Text('Safety Circle (M14)'),
                  onPressed: () => Get.toNamed(Routes.SAFETY_CIRCLE),
                ),
                ActionChip(
                  avatar: const Icon(Icons.apartment, size: 18),
                  label: const Text('Institution Center (M17)'),
                  onPressed: () => Get.toNamed(Routes.INSTITUTION_DASHBOARD),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
