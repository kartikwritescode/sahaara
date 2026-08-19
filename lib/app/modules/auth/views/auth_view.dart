import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../../../core/constants/app_colors.dart';

class AuthView extends GetView<AuthController> {
  AuthView({super.key});

  final TextEditingController emailController = TextEditingController(text: 'senior@sahaara.org');
  final TextEditingController passwordController = TextEditingController(text: 'password123');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shield_outlined, size: 72, color: AppColors.primary),
              const SizedBox(height: 12),
              const Text(
                'Sahaara ElderGuard',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const Text(
                'AI Safety Layer for Elderly Care',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 32),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Obx(() => Row(
                        children: [
                          Expanded(
                            child: ChoiceChip(
                              label: const Text('Senior'),
                              selected: controller.selectedRole.value == 'senior',
                              onSelected: (val) => controller.selectedRole.value = 'senior',
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ChoiceChip(
                              label: const Text('Caregiver'),
                              selected: controller.selectedRole.value == 'caregiver',
                              onSelected: (val) => controller.selectedRole.value = 'caregiver',
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ChoiceChip(
                              label: const Text('Facility'),
                              selected: controller.selectedRole.value == 'institution_admin',
                              onSelected: (val) => controller.selectedRole.value = 'institution_admin',
                            ),
                          ),
                        ],
                      )),
                      const SizedBox(height: 20),
                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email Address',
                          prefixIcon: Icon(Icons.email_outlined),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock_outline),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Obx(() => controller.isLoading.value
                          ? const CircularProgressIndicator()
                          : SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed: () {
                                  controller.login(emailController.text, passwordController.text);
                                },
                                child: const Text('Sign In / Continue', style: TextStyle(color: Colors.white, fontSize: 16)),
                              ),
                            )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
