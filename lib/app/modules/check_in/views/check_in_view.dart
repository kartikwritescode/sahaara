import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/check_in_controller.dart';
import '../../../core/constants/app_colors.dart';

class CheckInView extends GetView<CheckInController> {
  const CheckInView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Check-In (M2)'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Obx(() => Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const Icon(Icons.notifications_active_outlined, size: 64, color: AppColors.primary),
                    const SizedBox(height: 16),
                    const Text(
                      'Scheduled Safety Check-In',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Are you safe and feeling okay?',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    if (controller.isPromptActive.value) ...[
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        icon: const Icon(Icons.check_circle, color: Colors.white),
                        label: const Text("I'm Safe", style: TextStyle(color: Colors.white, fontSize: 18)),
                        onPressed: () => controller.sendResponse('safe'),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        icon: const Icon(Icons.sos, color: Colors.white),
                        label: const Text('I Need Help', style: TextStyle(color: Colors.white, fontSize: 18)),
                        onPressed: () => controller.sendResponse('need_help'),
                      ),
                    ] else ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Recorded Response: ${controller.lastResponse.value}',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            )),
            const Spacer(),
            OutlinedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Simulate Scheduled Prompt Notification'),
              onPressed: controller.triggerNewCheckInPrompt,
            ),
          ],
        ),
      ),
    );
  }
}
