import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/caregiver_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/risk_status_chip.dart';
import '../../../routes/app_routes.dart';

class CaregiverDashboardView extends GetView<CaregiverController> {
  const CaregiverDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Caregiver Family Dashboard (M7)'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.loadSeniors,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: controller.seniors.length,
          itemBuilder: (context, index) {
            final senior = controller.seniors[index];
            final int score = senior.riskScore;

            return Card(
              elevation: 3,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.primary.withOpacity(0.2),
                  child: Text(
                    (senior.fullName.isNotEmpty ? senior.fullName : 'S')[0],
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: AppColors.primary),
                  ),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      senior.fullName.isNotEmpty ? senior.fullName : 'Senior',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    RiskStatusChip(score: score),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),
                    Text('Relationship: ${senior.relationship}'),
                    Text('Last Activity: ${senior.lastActive}'),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          icon: const Icon(Icons.shield_outlined, size: 16, color: Colors.white),
                          label: const Text('Incident Detail', style: TextStyle(color: Colors.white, fontSize: 12)),
                          onPressed: () => Get.toNamed(Routes.INCIDENTS),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton.icon(
                          icon: const Icon(Icons.map, size: 16),
                          label: const Text('Live Map', style: TextStyle(fontSize: 12)),
                          onPressed: () => Get.toNamed(Routes.GEOFENCING),
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
