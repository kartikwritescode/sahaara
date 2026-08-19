import 'package:get/get.dart';
import '../repository/risk_repository.dart';
import '../../../../data/models/risk_score_model.dart';

class RiskController extends GetxController {
  final RiskRepository _repository = RiskRepository();

  var isLoading = false.obs;
  var currentRisk = Rxn<RiskScoreModel>();

  @override
  void onInit() {
    super.onInit();
    refreshRiskScore();
  }

  Future<void> refreshRiskScore() async {
    isLoading.value = true;
    currentRisk.value = await _repository.fetchLatestRiskScore('mock-senior-id');
    isLoading.value = false;
  }
}
