import 'package:get/get.dart';
import '../repository/incident_repository.dart';
import '../../../../data/models/incident_model.dart';
import '../../../../data/services/notification_service.dart';

class IncidentController extends GetxController {
  final IncidentRepository _repository = IncidentRepository();
  final NotificationService _notificationService = Get.find<NotificationService>();

  var isLoading = false.obs;
  var incidents = <IncidentModel>[].obs;
  var currentEscalationLevel = 1.obs; // 0=senior prompt, 1=primary caregiver, 2=secondary

  @override
  void onInit() {
    super.onInit();
    loadIncidents();
  }

  Future<void> loadIncidents() async {
    isLoading.value = true;
    incidents.value = await _repository.fetchIncidents('mock-senior-id');
    isLoading.value = false;
  }

  Future<void> markSafeAndResolve(String incidentId) async {
    await _repository.resolveIncident(incidentId);
    Get.snackbar('Resolved', 'Incident marked safe and closed.');
    loadIncidents();
  }

  void escalateToNextLevel() {
    currentEscalationLevel.value += 1;
    _notificationService.showNotification(
      id: 201,
      title: 'Incident Escalated to Level ${currentEscalationLevel.value}',
      body: 'Notifying next priority contact in Safety Circle.',
    );
    Get.snackbar('Escalated', 'Notification sent to priority level ${currentEscalationLevel.value} contact.');
  }
}
