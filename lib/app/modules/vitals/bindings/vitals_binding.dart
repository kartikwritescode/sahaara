import 'package:get/get.dart';
import '../controllers/vitals_controller.dart';

class VitalsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VitalsController>(() => VitalsController());
  }
}
