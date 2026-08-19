import 'package:get/get.dart';
import '../models/risk_score_model.dart';

class RiskCalcService extends GetxService {
  RiskScoreModel calculateMockRiskScore(String seniorId, {bool missedCheckin = false, int hoursInactive = 0}) {
    int score = 0;
    List<RiskScoreFactor> factors = [];

    if (hoursInactive > 3) {
      int pts = (hoursInactive * 10).clamp(0, 40);
      score += pts;
      factors.add(RiskScoreFactor(label: 'Inactivity ($hoursInactive hours)', points: pts));
    }

    if (missedCheckin) {
      score += 30;
      factors.add(RiskScoreFactor(label: 'Missed Check-in', points: 30));
    }

    score = score.clamp(0, 100);
    String level = 'normal';
    if (score >= 81) level = 'critical';
    else if (score >= 61) level = 'concern';
    else if (score >= 31) level = 'attention';

    return RiskScoreModel(
      id: 'mock-risk-${DateTime.now().millisecondsSinceEpoch}',
      seniorId: seniorId,
      score: score,
      level: level,
      factors: factors,
      computedAt: DateTime.now(),
    );
  }
}
