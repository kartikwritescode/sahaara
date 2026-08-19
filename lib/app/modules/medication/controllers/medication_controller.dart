import 'package:get/get.dart';
import '../repository/medication_repository.dart';
import '../../../data/models/medication_model.dart';

class MedicationController extends GetxController {
  final MedicationRepository _repository = MedicationRepository();

  var isLoading = false.obs;
  var medications = <MedicationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchMedications();
  }

  Future<void> fetchMedications() async {
    isLoading.value = true;
    final res = await _repository.getMedications('mock-senior-id');
    medications.assignAll(res);
    isLoading.value = false;
  }

  Future<void> confirmTake(String id) async {
    Get.snackbar('Medication Taken', 'Logged medication confirmation.');
  }
}
