import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/medication_controller.dart';
import '../../../core/constants/app_colors.dart';

class MedicationView extends GetView<MedicationController> {
  const MedicationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medication Signals (M9)'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.medications.length,
          itemBuilder: (context, index) {
            final med = controller.medications[index];
            return Card(
              child: ListTile(
                leading: const Icon(Icons.medical_services_outlined, color: AppColors.primary),
                title: Text(med.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Dosage: ${med.dosage ?? 'As prescribed'} | Time: ${med.scheduleTimes?.join(", ") ?? "Daily"}'),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () => controller.confirmTake(med.id),
                  child: const Text('Confirm Take', style: TextStyle(color: Colors.white)),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
