import 'package:get/get.dart';
import '../repository/incident_repository.dart';
import '../../../data/models/incident_model.dart';
import '../../../data/services/notification_service.dart';

class IncidentController extends GetxController {
  final IncidentRepository _repository = IncidentRepository();
  final NotificationService _notificationService = Get.find<NotificationService>();

  var isLoading = false.obs;
  var incidents = <IncidentModel>[].obs;
  var currentEscalationLevel = 1.obs;

  @override
  void onInit() {
    super.onInit();
    fetchIncidents();
  }

  Future<void> fetchIncidents() async {
    isLoading.value = true;
    final res = await _repository.getIncidents('mock-senior-id');
    incidents.assignAll(res);
    isLoading.value = false;
  }

  void markSafeAndResolve([String? incidentId]) {
    currentEscalationLevel.value = 0;
    Get.snackbar('Resolved', 'Senior marked safe. Escalation cleared.');
  }

  void escalateToNextLevel() {
    currentEscalationLevel.value += 1;
    _notificationService.showNotification(
      id: 201,
      title: 'Incident Escalated',
      body: 'Escalated to level ${currentEscalationLevel.value}',
    );
  }
}
