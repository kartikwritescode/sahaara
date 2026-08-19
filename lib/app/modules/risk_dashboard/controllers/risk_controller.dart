import 'package:get/get.dart';
import '../repository/risk_repository.dart';
import '../../../data/models/risk_score_model.dart';

class RiskController extends GetxController {
  final RiskRepository _repository = RiskRepository();

  var isLoading = false.obs;
  var currentRiskScore = Rxn<RiskScoreModel>();

  RiskScoreModel? get currentRisk => currentRiskScore.value;

  @override
  void onInit() {
    super.onInit();
    fetchRiskScore();
  }

  Future<void> fetchRiskScore() async {
    isLoading.value = true;
    final res = await _repository.getLatestRiskScore('mock-senior-id');
    currentRiskScore.value = res;
    isLoading.value = false;
  }
}
