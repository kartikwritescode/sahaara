import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/activity_log_controller.dart';
import '../../../core/constants/app_colors.dart';

class ActivityLogView extends GetView<ActivityLogController> {
  const ActivityLogView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity & Signal Logging (M3)'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: Row(
              children: [
                const Icon(Icons.sensors, color: AppColors.primary),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Normalized substrate reading app opens, movement, check-ins, and med confirms.',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                  onPressed: controller.logManualActivity,
                  child: const Text("I'm Active", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() => ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.events.length,
              itemBuilder: (context, index) {
                final ev = controller.events[index];
                return ListTile(
                  leading: const Icon(Icons.history, color: AppColors.primary),
                  title: Text(ev.eventType.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Source: ${ev.source} | ${ev.occurredAt.hour}:${ev.occurredAt.minute}'),
                );
              },
            )),
          ),
        ],
      ),
    );
  }
}
