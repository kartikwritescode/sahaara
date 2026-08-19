import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/institution_controller.dart';
import '../../../core/constants/app_colors.dart';

class InstitutionDashboardView extends GetView<InstitutionController> {
  const InstitutionDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Institution Command Center (M17)'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Sunrise Elder Care Facility Overview', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildStatCard('Total Residents', '${controller.totalResidents.value}', Colors.blue),
                _buildStatCard('Safe 🟢', '${controller.safeCount.value}', Colors.green),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildStatCard('Attention 🟡', '${controller.attentionCount.value}', Colors.amber),
                _buildStatCard('Critical 🔴', '${controller.criticalCount.value}', Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String count, Color color) {
    return Expanded(
      child: Card(
        color: color.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text(count, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: color)),
              const SizedBox(height: 4),
              Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
