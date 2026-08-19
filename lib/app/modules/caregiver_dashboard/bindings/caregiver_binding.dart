import 'package:get/get.dart';
import '../controllers/caregiver_controller.dart';

class CaregiverBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CaregiverController>(() => CaregiverController());
  }
}
