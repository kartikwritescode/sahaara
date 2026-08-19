import 'package:get/get.dart';
import '../../../data/models/profile_model.dart';
import '../../../data/services/supabase_service.dart';

class CaregiverRepository {
  final SupabaseService _supabase = Get.find<SupabaseService>();

  Future<List<ProfileModel>> getLinkedSeniors(String caregiverId) async {
    try {
      final res = await _supabase.client
          .from('care_links')
          .select('seniors:profiles!receiver_id(*)')
          .eq('caregiver_id', caregiverId);
      return (res as List).map((e) => ProfileModel.fromJson(e['seniors'])).toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<ProfileModel>> fetchLinkedSeniors(String caregiverId) async {
    return getLinkedSeniors(caregiverId);
  }
}
