import 'package:get/get.dart';
import '../repository/vitals_repository.dart';
import '../../../data/models/vitals_model.dart';

class VitalsController extends GetxController {
  final VitalsRepository _repository = VitalsRepository();

  var isLoading = false.obs;
  var latestVitals = Rxn<VitalsModel>();

  @override
  void onInit() {
    super.onInit();
    fetchVitals();
  }

  Future<void> fetchVitals() async {
    isLoading.value = true;
    final res = await _repository.getLatestVitals('mock-senior-id');
    latestVitals.value = res;
    isLoading.value = false;
  }
}
