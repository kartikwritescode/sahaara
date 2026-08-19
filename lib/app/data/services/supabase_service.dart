import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/env/env.dart';

class SupabaseService extends GetxService {
  late final SupabaseClient client;

  Future<SupabaseService> init() async {
    if (Env.supabaseUrl.isNotEmpty && Env.supabaseAnonKey.isNotEmpty) {
      await Supabase.initialize(
        url: Env.supabaseUrl,
        anonKey: Env.supabaseAnonKey,
      );
      client = Supabase.instance.client;
    } else {
      // Mock client or fallback when keys aren't yet populated in .env
      client = SupabaseClient('https://placeholder.supabase.co', 'placeholder');
    }
    return this;
  }

  User? get currentUser => client.auth.currentUser;
  bool get isAuthenticated => currentUser != null;
}
