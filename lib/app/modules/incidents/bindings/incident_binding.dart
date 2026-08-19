import 'package:get/get.dart';
import '../controllers/incident_controller.dart';

class IncidentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IncidentController>(() => IncidentController());
  }
}
