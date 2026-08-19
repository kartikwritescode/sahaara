import 'package:get/get.dart';
import '../../../data/models/medication_model.dart';
import '../../../data/services/supabase_service.dart';

class MedicationRepository {
  final SupabaseService _supabase = Get.find<SupabaseService>();

  Future<List<MedicationModel>> getMedications(String seniorId) async {
    try {
      final res = await _supabase.client
          .from('medications')
          .select()
          .eq('senior_id', seniorId);
      return (res as List).map((e) => MedicationModel.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }
}
