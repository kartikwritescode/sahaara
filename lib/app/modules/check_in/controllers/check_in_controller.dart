import 'package:get/get.dart';
import '../repository/check_in_repository.dart';
import '../../../data/models/check_in_model.dart';
import '../../../data/services/notification_service.dart';

class CheckInController extends GetxController {
  final CheckInRepository _repository = CheckInRepository();
  final NotificationService _notificationService = Get.find<NotificationService>();

  var isLoading = false.obs;
  var checkIns = <CheckInModel>[].obs;
  var isPromptActive = true.obs;
  var lastResponse = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetchCheckIns();
  }

  Future<void> fetchCheckIns() async {
    isLoading.value = true;
    final res = await _repository.getPendingCheckIns('mock-senior-id');
    checkIns.assignAll(res);
    isLoading.value = false;
  }

  Future<void> sendResponse(String status) async {
    lastResponse.value = status;
    isPromptActive.value = false;
    _notificationService.showNotification(
      id: 101,
      title: 'Check-In Recorded',
      body: 'Status: $status',
    );
  }

  void triggerNewCheckInPrompt() {
    isPromptActive.value = true;
  }

  Future<void> confirmCheckIn(String id) async {
    final success = await _repository.respondToCheckIn(id, 'confirmed');
    if (success) {
      checkIns.removeWhere((item) => item.id == id);
      sendResponse('confirmed');
    }
  }
}
