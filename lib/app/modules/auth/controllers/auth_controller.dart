import 'package:get/get.dart';
import '../repository/auth_repository.dart';
import '../../../routes/app_routes.dart';

class AuthController extends GetxController {
  final AuthRepository _repository = AuthRepository();

  var isLoading = false.obs;
  var selectedRole = 'senior'.obs;

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    bool success = await _repository.signIn(email, password);
    isLoading.value = false;

    if (success) {
      if (selectedRole.value == 'caregiver') {
        Get.offAllNamed(Routes.CAREGIVER_DASHBOARD);
      } else if (selectedRole.value == 'institution_admin') {
        Get.offAllNamed(Routes.INSTITUTION_DASHBOARD);
      } else {
        Get.offAllNamed(Routes.SENIOR_PROFILE);
      }
    } else {
      Get.snackbar('Auth Failed', 'Invalid credentials or connection issue.');
      // For demo fallback: proceed anyway
      if (selectedRole.value == 'caregiver') {
        Get.offAllNamed(Routes.CAREGIVER_DASHBOARD);
      } else {
        Get.offAllNamed(Routes.SENIOR_PROFILE);
      }
    }
  }

  Future<void> register(String email, String password, String fullName) async {
    isLoading.value = true;
    await _repository.signUp(email, password, fullName, selectedRole.value);
    isLoading.value = false;
    login(email, password);
  }
}
