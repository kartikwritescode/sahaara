import 'package:get/get.dart';
import '../controllers/institution_controller.dart';

class InstitutionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InstitutionController>(() => InstitutionController());
  }
}
