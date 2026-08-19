import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/risk_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/risk_band_helper.dart';

class RiskDashboardView extends GetView<RiskController> {
  const RiskDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Risk Engine & Explainability (M4/M12)'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final risk = controller.currentRisk;
        if (risk == null) {
          return const Center(child: Text('No risk score computed yet.'));
        }

        final color = RiskBandHelper.getColor(risk.score);
        final label = RiskBandHelper.getLabel(risk.score);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 140,
                            height: 140,
                            child: CircularProgressIndicator(
                              value: risk.score / 100,
                              strokeWidth: 12,
                              backgroundColor: Colors.grey.shade200,
                              color: color,
                            ),
                          ),
                          Column(
                            children: [
                              Text(
                                '${risk.score}',
                                style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: color),
                              ),
                              const Text('/100', style: TextStyle(color: AppColors.textSecondary)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        label,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Computed at ${risk.computedAt.hour.toString().padLeft(2, '0')}:${risk.computedAt.minute.toString().padLeft(2, '0')}',
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Explainable Contributing Factors (M12)',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Sahaara breaks down the exact weighted terms contributing to this score:',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                      ),
                      const Divider(height: 24),
                      if (risk.factors.isEmpty)
                        const Text('🟢 All baseline signals normal (+0 points)', style: TextStyle(color: Colors.green))
                      else
                        ...risk.factors.map(
                          (factor) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: Row(
                              children: [
                                const Icon(Icons.add_circle_outline, color: Colors.orange, size: 20),
                                const SizedBox(width: 8),
                                Expanded(child: Text(factor.label, style: const TextStyle(fontWeight: FontWeight.w500))),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.shade50,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text('+${factor.points} pts', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
