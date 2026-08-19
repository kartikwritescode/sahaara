import 'package:get/get.dart';
import '../../../../data/models/senior_profile_model.dart';
import '../../../../data/services/supabase_service.dart';

class SeniorProfileRepository {
  final SupabaseService _supabase = Get.find<SupabaseService>();

  Future<SeniorProfileModel?> fetchSeniorProfile(String id) async {
    try {
      final res = await _supabase.client
          .from('senior_profiles')
          .select()
          .eq('id', id)
          .maybeSingle();
      if (res != null) {
        return SeniorProfileModel.fromJson(res);
      }
    } catch (_) {}
    return null;
  }

  Future<bool> saveSeniorProfile(SeniorProfileModel profile) async {
    try {
      await _supabase.client.from('senior_profiles').upsert(profile.toJson());
      return true;
    } catch (_) {
      return false;
    }
  }
}
