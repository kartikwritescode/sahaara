import 'package:get/get.dart';
import '../../../../data/models/incident_model.dart';
import '../../../../data/services/supabase_service.dart';

class IncidentRepository {
  final SupabaseService _supabase = Get.find<SupabaseService>();

  Future<List<IncidentModel>> fetchIncidents(String seniorId) async {
    try {
      final res = await _supabase.client
          .from('incidents')
          .select()
          .eq('senior_id', seniorId)
          .order('created_at', ascending: false);

      return (res as List).map((i) => IncidentModel.fromJson(i)).toList();
    } catch (_) {
      return [
        IncidentModel(
          id: 'inc-001',
          seniorId: seniorId,
          riskScoreId: 'risk-75',
          status: 'open',
          aiSummary: 'AI Summary: Senior missed recent safety check-in and remained stationary for >4 hours during routine active window.',
          createdAt: DateTime.now().subtract(const Duration(minutes: 12)),
        ),
      ];
    }
  }

  Future<bool> resolveIncident(String incidentId) async {
    try {
      await _supabase.client.from('incidents').update({
        'status': 'resolved',
        'resolved_at': DateTime.now().toIso8601String(),
      }).eq('id', incidentId);
      return true;
    } catch (_) {
      return false;
    }
  }
}
