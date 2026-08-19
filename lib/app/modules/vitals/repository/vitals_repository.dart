import 'package:get/get.dart';
import '../../../data/models/vitals_model.dart';
import '../../../data/services/supabase_service.dart';

class VitalsRepository {
  final SupabaseService _supabase = Get.find<SupabaseService>();

  Future<VitalsModel?> getLatestVitals(String seniorId) async {
    try {
      final res = await _supabase.client
          .from('vitals')
          .select()
          .eq('senior_id', seniorId)
          .order('recorded_at', ascending: false)
          .limit(1)
          .maybeSingle();
      if (res != null) return VitalsModel.fromJson(res);
      return null;
    } catch (_) {
      return null;
    }
  }
}
