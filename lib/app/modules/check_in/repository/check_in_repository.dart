import 'package:get/get.dart';
import '../../../data/models/check_in_model.dart';
import '../../../data/services/supabase_service.dart';

class CheckInRepository {
  final SupabaseService _supabase = Get.find<SupabaseService>();

  Future<List<CheckInModel>> getPendingCheckIns(String seniorId) async {
    try {
      final res = await _supabase.client
          .from('check_ins')
          .select()
          .eq('senior_id', seniorId)
          .eq('status', 'pending');
      return (res as List).map((e) => CheckInModel.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<bool> respondToCheckIn(String id, String status) async {
    try {
      await _supabase.client
          .from('check_ins')
          .update({'status': status, 'responded_at': DateTime.now().toIso8601String()})
          .eq('id', id);
      return true;
    } catch (_) {
      return false;
    }
  }
}
