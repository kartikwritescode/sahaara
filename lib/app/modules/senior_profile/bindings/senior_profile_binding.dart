import 'package:get/get.dart';
import '../controllers/senior_profile_controller.dart';

class SeniorProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SeniorProfileController>(() => SeniorProfileController());
  }
}
