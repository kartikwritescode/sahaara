import 'package:get/get.dart';
import '../../../../data/models/risk_score_model.dart';
import '../../../../data/services/supabase_service.dart';
import '../../../../data/services/risk_calc_service.dart';

class RiskRepository {
  final SupabaseService _supabase = Get.find<SupabaseService>();
  final RiskCalcService _calcService = Get.find<RiskCalcService>();

  Future<RiskScoreModel> fetchLatestRiskScore(String seniorId) async {
    try {
      final res = await _supabase.client
          .from('risk_scores')
          .select()
          .eq('senior_id', seniorId)
          .order('computed_at', ascending: false)
          .limit(1)
          .maybeSingle();

      if (res != null) {
        return RiskScoreModel.fromJson(res);
      }
    } catch (_) {}

    // Fallback mock risk score with explainable factors
    return _calcService.calculateMockRiskScore(seniorId, missedCheckin: true, hoursInactive: 5);
  }
}
