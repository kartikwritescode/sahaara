import 'package:get/get.dart';
import '../repository/safety_timeline_repository.dart';
import '../models/timeline_entry.dart';

class SafetyTimelineController extends GetxController {
  final SafetyTimelineRepository _repository = SafetyTimelineRepository();

  var isLoading = false.obs;
  var entries = <TimelineEntry>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchTimeline();
  }

  Future<void> fetchTimeline() async {
    isLoading.value = true;
    final res = await _repository.getTimeline('mock-senior-id');
    entries.assignAll(res);
    isLoading.value = false;
  }
}
