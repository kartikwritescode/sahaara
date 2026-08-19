import 'package:get/get.dart';
import '../../../../data/models/medication_model.dart';
import '../../../../data/services/supabase_service.dart';

class MedicationRepository {
  final SupabaseService _supabase = Get.find<SupabaseService>();

  Future<List<MedicationModel>> fetchMedications(String seniorId) async {
    try {
      final res = await _supabase.client.from('medications').select().eq('senior_id', seniorId);
      return (res as List).map((m) => MedicationModel.fromJson(m)).toList();
    } catch (_) {
      return [
        MedicationModel(id: 'med-1', seniorId: seniorId, name: 'Aspirin 75mg', dosage: '1 Tablet', scheduleTimes: ['08:00 AM'], active: true),
        MedicationModel(id: 'med-2', seniorId: seniorId, name: 'Blood Pressure Med', dosage: '1 Capsule', scheduleTimes: ['08:00 PM'], active: true),
      ];
    }
  }

  Future<bool> confirmMedication(String medId) async {
    try {
      await _supabase.client.from('medication_logs').insert({
        'medication_id': medId,
        'scheduled_time': DateTime.now().toIso8601String(),
        'confirmed_at': DateTime.now().toIso8601String(),
        'status': 'confirmed',
      });
      return true;
    } catch (_) {
      return false;
    }
  }
}
