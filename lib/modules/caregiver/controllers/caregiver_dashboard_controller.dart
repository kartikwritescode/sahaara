import 'package:get/get.dart';

class CaregiverDashboardController extends GetxController {
  var isLoading = false.obs;
  var selectedSeniorName = 'Robert Smith'.obs;
  var seniorRiskScore = 72.obs;
  var receiverId = 'rec-123'.obs;

  var heartRate = '72'.obs;
  var oxygen = '98'.obs;
  var fallDetected = false.obs;
  var steps = 4250.obs;

  var receiverMood = 'happy'.obs;
  var moodAvailable = true.obs;
  var battery = 85.obs;
  var isCharging = false.obs;
  var fitbitConnected = true.obs;
  var isRefreshing = false.obs;
  var lastLocationUpdate = Rxn<DateTime>(DateTime.now());

  void refreshDashboard() {
    refreshData();
  }

  Future<void> refreshData() async {
    isRefreshing.value = true;
    await Future.delayed(const Duration(milliseconds: 600));
    lastLocationUpdate.value = DateTime.now();
    isRefreshing.value = false;
  }
}
