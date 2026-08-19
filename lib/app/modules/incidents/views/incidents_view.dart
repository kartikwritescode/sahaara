import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/incident_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../routes/app_routes.dart';

class IncidentsView extends GetView<IncidentController> {
  const IncidentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Incidents & Escalations (M5/M6/M11/M15)'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.incidents.isEmpty) {
          return const Center(child: Text('No active safety incidents.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: controller.incidents.length,
          itemBuilder: (context, index) {
            final incident = controller.incidents[index];
            return Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Chip(
                          avatar: const Icon(Icons.warning, color: Colors.white, size: 16),
                          label: Text(
                            incident.status.toUpperCase(),
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          backgroundColor: incident.status == 'open' ? Colors.red : Colors.green,
                        ),
                        Obx(() => Text(
                          'Escalation Level: ${controller.currentEscalationLevel.value}',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                        )),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // AI Summary Banner (M11)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.auto_awesome, color: AppColors.primary, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              incident.aiSummary ?? 'AI summary generating...',
                              style: const TextStyle(fontSize: 13, height: 1.4, color: AppColors.textPrimary),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('One-Tap Actions (M15):', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                          icon: const Icon(Icons.check, color: Colors.white, size: 18),
                          label: const Text('Mark Safe', style: TextStyle(color: Colors.white)),
                          onPressed: () => controller.markSafeAndResolve(incident.id),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                          icon: const Icon(Icons.arrow_upward, color: Colors.white, size: 18),
                          label: const Text('Escalate Next', style: TextStyle(color: Colors.white)),
                          onPressed: controller.escalateToNextLevel,
                        ),
                        OutlinedButton.icon(
                          icon: const Icon(Icons.map, size: 18),
                          label: const Text('View Location (M8)'),
                          onPressed: () => Get.toNamed(Routes.GEOFENCING),
                        ),
                        OutlinedButton.icon(
                          icon: const Icon(Icons.call, size: 18),
                          label: const Text('Call Senior'),
                          onPressed: () => Get.snackbar('Call', 'Dialing senior emergency number...'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
