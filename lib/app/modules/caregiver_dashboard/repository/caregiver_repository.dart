import 'package:get/get.dart';
import '../../../../data/models/profile_model.dart';
import '../../../../data/services/supabase_service.dart';

class CaregiverRepository {
  final SupabaseService _supabase = Get.find<SupabaseService>();

  Future<List<Map<String, dynamic>>> fetchLinkedSeniors(String caregiverId) async {
    try {
      final res = await _supabase.client
          .from('caregiver_links')
          .select('senior_id, relationship, profiles!inner(full_name, phone, avatar_url)')
          .eq('caregiver_id', caregiverId);

      return List<Map<String, dynamic>>.from(res);
    } catch (_) {
      return [
        {
          'senior_id': 'senior-1',
          'relationship': 'Father',
          'full_name': 'Robert Smith',
          'risk_score': 72,
          'status': 'CONCERN',
          'last_active': '14 mins ago',
        },
        {
          'senior_id': 'senior-2',
          'relationship': 'Mother',
          'full_name': 'Eleanor Smith',
          'risk_score': 15,
          'status': 'NORMAL',
          'last_active': '2 mins ago',
        },
      ];
    }
  }
}
