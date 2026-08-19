import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/vitals_controller.dart';
import '../../../core/constants/app_colors.dart';

class VitalsPanelView extends GetView<VitalsController> {
  const VitalsPanelView({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Obx(() {
          final v = controller.latestVitals.value;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Vitals Summary', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Heart Rate: ${v?.heartRateBpm ?? "--"} bpm'),
                  Text('SpO2: ${v?.spo2Percent ?? "--"}%'),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Context only — not a medical diagnosis.',
                style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
              ),
            ],
          );
        }),
      ),
    );
  }
}
