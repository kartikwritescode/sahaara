import 'package:get/get.dart';
import '../repository/medication_repository.dart';
import '../../../../data/models/medication_model.dart';

class MedicationController extends GetxController {
  final MedicationRepository _repository = MedicationRepository();

  var isLoading = false.obs;
  var medications = <MedicationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadMeds();
  }

  Future<void> loadMeds() async {
    isLoading.value = true;
    medications.value = await _repository.fetchMedications('mock-senior-id');
    isLoading.value = false;
  }

  Future<void> confirmTake(String medId) async {
    await _repository.confirmMedication(medId);
    Get.snackbar('Confirmed', 'Medication confirmation feeds positive signal to Risk Engine.');
  }
}
