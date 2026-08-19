import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/safety_circle_controller.dart';
import '../../../core/constants/app_colors.dart';

class SafetyCircleView extends GetView<SafetyCircleController> {
  const SafetyCircleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Safety Circle Escalation Tree (M14)'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Obx(() => ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.contacts.length,
        itemBuilder: (context, index) {
          final c = controller.contacts[index];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.primary,
                child: Text('${c['priority']}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              title: Text(c['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Role: ${c['role']} | Escalation Order: Level ${c['priority']}'),
              trailing: c['is_primary'] == true
                  ? const Chip(label: Text('PRIMARY', style: TextStyle(fontSize: 10, color: Colors.white)), backgroundColor: Colors.green)
                  : null,
            ),
          );
        },
      )),
    );
  }
}
