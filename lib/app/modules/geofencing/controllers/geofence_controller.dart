import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../repository/geofence_repository.dart';
import '../../../data/models/geofence_model.dart';

class GeofenceController extends GetxController {
  final GeofenceRepository _repository = GeofenceRepository();

  var isLoading = false.obs;
  var geofences = <GeofenceModel>[].obs;
  var currentSeniorPos = const LatLng(37.7749, -122.4194).obs;

  @override
  void onInit() {
    super.onInit();
    loadGeofences();
  }

  Future<void> loadGeofences() async {
    isLoading.value = true;
    final res = await _repository.getGeofences('mock-senior-id');
    geofences.assignAll(res);
    isLoading.value = false;
  }
}
