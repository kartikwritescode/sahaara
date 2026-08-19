import 'package:get/get.dart';
import '../controllers/safety_circle_controller.dart';

class SafetyCircleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SafetyCircleController>(() => SafetyCircleController());
  }
}
