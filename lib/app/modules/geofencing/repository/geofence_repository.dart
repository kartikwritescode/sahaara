import 'package:get/get.dart';
import '../../../data/models/geofence_model.dart';
import '../../../data/services/supabase_service.dart';

class GeofenceRepository {
  final SupabaseService _supabase = Get.find<SupabaseService>();

  Future<List<GeofenceModel>> getGeofences(String seniorId) async {
    try {
      final res = await _supabase.client
          .from('geofences')
          .select()
          .eq('receiver_id', seniorId);
      return (res as List).map((e) => GeofenceModel.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<bool> saveGeofence(GeofenceModel geofence) async {
    try {
      await _supabase.client.from('geofences').insert(geofence.toJson());
      return true;
    } catch (_) {
      return false;
    }
  }
}
