import 'package:get/get.dart';
import '../repository/caregiver_repository.dart';
import '../../../data/models/profile_model.dart';

class CaregiverController extends GetxController {
  final CaregiverRepository _repository = CaregiverRepository();

  var isLoading = false.obs;
  var seniors = <ProfileModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadSeniors();
  }

  Future<void> loadSeniors() async {
    isLoading.value = true;
    final result = await _repository.fetchLinkedSeniors('mock-caregiver-id');
    seniors.assignAll(result);
    isLoading.value = false;
  }
}
