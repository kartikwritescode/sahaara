import 'package:get/get.dart';
import '../../../data/models/incident_model.dart';
import '../../../data/services/supabase_service.dart';

class IncidentRepository {
  final SupabaseService _supabase = Get.find<SupabaseService>();

  Future<List<IncidentModel>> getIncidents(String seniorId) async {
    try {
      final res = await _supabase.client
          .from('incidents')
          .select()
          .eq('senior_id', seniorId)
          .order('created_at', ascending: false);
      return (res as List).map((e) => IncidentModel.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }
}
