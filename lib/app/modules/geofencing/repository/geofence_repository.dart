import 'package:get/get.dart';
import '../../../../data/models/geofence_model.dart';
import '../../../../data/services/supabase_service.dart';

class GeofenceRepository {
  final SupabaseService _supabase = Get.find<SupabaseService>();

  Future<List<GeofenceModel>> fetchGeofences(String seniorId) async {
    try {
      final res = await _supabase.client
          .from('geofences')
          .select()
          .eq('senior_id', seniorId);
      return (res as List).map((g) => GeofenceModel.fromJson(g)).toList();
    } catch (_) {
      return [
        GeofenceModel(
          id: 'geo-1',
          seniorId: seniorId,
          name: 'Home Safety Zone',
          centerLat: 37.7749,
          centerLng: -122.4194,
          radiusM: 500,
          zoneType: 'home',
        ),
      ];
    }
  }
}
