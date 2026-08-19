import 'package:get/get.dart';
import '../../../../data/models/check_in_model.dart';
import '../../../../data/services/supabase_service.dart';

class CheckInRepository {
  final SupabaseService _supabase = Get.find<SupabaseService>();

  Future<bool> respondToCheckIn(String checkInId, String response) async {
    try {
      await _supabase.client.from('check_ins').update({
        'response': response,
        'responded_at': DateTime.now().toIso8601String(),
      }).eq('id', checkInId);
      return true;
    } catch (_) {
      return false;
    }
  }
}
