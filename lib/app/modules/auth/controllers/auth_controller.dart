import 'package:get/get.dart';
import '../repository/auth_repository.dart';
import '../../../routes/app_routes.dart';

class UserModelMock {
  final String id;
  final String fullName;
  final String email;
  final String role;
  final String? phone;
  final String? avatarUrl;
  final String? profileImage;
  final String? careId;

  UserModelMock({
    this.id = 'demo-user-id',
    this.fullName = 'Senior User',
    this.email = 'senior@sahaara.org',
    this.role = 'senior',
    this.phone = '+1 555-019-2834',
    this.avatarUrl,
    this.profileImage,
    this.careId = 'CARE-88214',
  });
}

class AuthController extends GetxController {
  final AuthRepository _repository = AuthRepository();

  var isLoading = false.obs;
  var selectedRole = 'senior'.obs;
  var user = Rxn<UserModelMock>(UserModelMock());

  Future<void> fetchRoleAndNavigate(String userId) async {
    Get.offAllNamed(Routes.SENIOR_PROFILE);
  }

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

  void logout() {
    Get.offAllNamed(Routes.AUTH);
  }
}
