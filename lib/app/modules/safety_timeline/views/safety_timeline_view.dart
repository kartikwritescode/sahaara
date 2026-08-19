import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/safety_timeline_controller.dart';
import '../../../core/constants/app_colors.dart';

class SafetyTimelineView extends GetView<SafetyTimelineController> {
  const SafetyTimelineView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Safety Activity Timeline'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.entries.isEmpty) {
          return const Center(child: Text('No safety events recorded.'));
        }

        return ListView.builder(
          itemCount: controller.entries.length,
          itemBuilder: (context, index) {
            final entry = controller.entries[index];
            return ListTile(
              leading: const Icon(Icons.event_note, color: AppColors.primary),
              title: Text(entry.title),
              subtitle: Text(entry.description),
              trailing: Text(
                '${entry.timestamp.hour}:${entry.timestamp.minute.toString().padLeft(2, "0")}',
              ),
            );
          },
        );
      }),
    );
  }
}
