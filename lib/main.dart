import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/core/env/env.dart';
import 'app/core/constants/app_colors.dart';
import 'app/data/services/supabase_service.dart';
import 'app/data/services/notification_service.dart';
import 'app/routes/app_pages.dart';
import 'main_binding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment configuration
  await Env.init();

  // Initialize global bindings
  MainBinding().dependencies();

  // Async service initialization
  await Get.find<SupabaseService>().init();
  await Get.find<NotificationService>().init();

  runApp(const SahaaraApp());
}

class SahaaraApp extends StatelessWidget {
  const SahaaraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Sahaara ElderGuard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
      ),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}
