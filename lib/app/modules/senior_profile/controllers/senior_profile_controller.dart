import 'package:get/get.dart';
import '../repository/senior_profile_repository.dart';
import '../../../data/models/senior_profile_model.dart';
import '../../../data/services/maps_service.dart';

class SeniorProfileController extends GetxController {
  final SeniorProfileRepository _repository = SeniorProfileRepository();
  final MapsService _mapsService = Get.find<MapsService>();

  var isLoading = false.obs;
  var currentProfile = Rxn<SeniorProfileModel>();

  var wakeTime = '07:00 AM'.obs;
  var sleepTime = '10:00 PM'.obs;
  var homeAddress = '123 Peace Avenue, Green Park'.obs;
  final RxDouble homeLat = 37.7749.obs;
  final RxDouble homeLng = (-122.4194).obs;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    isLoading.value = true;
    final profile = await _repository.fetchSeniorProfile('mock-senior-id');
    if (profile != null) {
      currentProfile.value = profile;
      if (profile.homeAddress != null) homeAddress.value = profile.homeAddress!;
      if (profile.wakeTime != null) wakeTime.value = profile.wakeTime!;
      if (profile.sleepTime != null) sleepTime.value = profile.sleepTime!;
    }
    isLoading.value = false;
  }

  Future<void> updateHomeLocationFromGPS() async {
    final pos = await _mapsService.getCurrentPosition();
    if (pos != null) {
      homeLat.value = pos.latitude;
      homeLng.value = pos.longitude;
      final addr = await _mapsService.getAddressFromCoordinates(pos.latitude, pos.longitude);
      if (addr != null) homeAddress.value = addr;
    }
  }

  Future<void> saveProfile() async {
    isLoading.value = true;
    final updated = SeniorProfileModel(
      id: 'mock-senior-id',
      age: 78,
      homeLat: homeLat.value,
      homeLng: homeLng.value,
      homeAddress: homeAddress.value,
      wakeTime: wakeTime.value,
      sleepTime: sleepTime.value,
      notes: 'No major allergies. Routine walker.',
    );
    await _repository.saveSeniorProfile(updated);
    currentProfile.value = updated;
    isLoading.value = false;
    Get.snackbar('Success', 'Senior routine and baseline saved.');
  }
}
