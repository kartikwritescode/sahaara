import 'package:get/get.dart';
import '../repository/caregiver_repository.dart';

class CaregiverController extends GetxController {
  final CaregiverRepository _repository = CaregiverRepository();

  var isLoading = false.obs;
  var seniors = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadSeniors();
  }

  Future<void> loadSeniors() async {
    isLoading.value = true;
    seniors.value = await _repository.fetchLinkedSeniors('mock-caregiver-id');
    isLoading.value = false;
  }
}
