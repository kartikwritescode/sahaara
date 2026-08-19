import 'package:get/get.dart';
import '../../../../data/services/supabase_service.dart';

class AuthRepository {
  final SupabaseService _supabase = Get.find<SupabaseService>();

  Future<bool> signIn(String email, String password) async {
    try {
      await _supabase.client.auth.signInWithPassword(email: email, password: password);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> signUp(String email, String password, String fullName, String role) async {
    try {
      final res = await _supabase.client.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName, 'role': role},
      );
      if (res.user != null) {
        await _supabase.client.from('profiles').insert({
          'id': res.user!.id,
          'role': role,
          'full_name': fullName,
        });
      }
      return true;
    } catch (_) {
      return false;
    }
  }
}
