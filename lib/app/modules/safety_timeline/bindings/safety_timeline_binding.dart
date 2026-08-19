import 'package:get/get.dart';
import '../controllers/safety_timeline_controller.dart';

class SafetyTimelineBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SafetyTimelineController>(() => SafetyTimelineController());
  }
}
