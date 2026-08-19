import 'package:get/get.dart';
import '../repository/check_in_repository.dart';
import '../../../../data/services/notification_service.dart';

class CheckInController extends GetxController {
  final CheckInRepository _repository = CheckInRepository();
  final NotificationService _notificationService = Get.find<NotificationService>();

  var lastResponse = 'Pending Prompt'.obs;
  var isPromptActive = true.obs;

  Future<void> sendResponse(String response) async {
    lastResponse.value = response;
    isPromptActive.value = false;
    await _repository.respondToCheckIn('mock-checkin-id', response);

    if (response == 'safe') {
      Get.snackbar('Status Recorded', 'Glad to hear you are safe!');
    } else if (response == 'need_help') {
      _notificationService.showNotification(
        id: 101,
        title: 'Emergency Help Triggered',
        body: 'Alert dispatched to your primary caregiver.',
      );
      Get.snackbar('Help Requested', 'Primary caregiver notified immediately!', snackPosition: SnackPosition.TOP);
    }
  }

  void triggerNewCheckInPrompt() {
    isPromptActive.value = true;
    _notificationService.showNotification(
      id: 102,
      title: 'Safety Check-In',
      body: 'Are you safe right now? Tap to respond.',
    );
  }
}
