import 'package:get/get.dart';
import '../controllers/risk_controller.dart';

class RiskBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RiskController>(() => RiskController());
  }
}
