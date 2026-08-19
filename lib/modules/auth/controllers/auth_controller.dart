import 'package:get/get.dart';
import 'package:sahaara/app/routes/app_routes.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  var user = Rxn<dynamic>({'id': 'demo-user-id', 'full_name': 'Senior User'});

  Future<void> fetchRoleAndNavigate(String userId) async {
    Get.offAllNamed(Routes.SENIOR_PROFILE);
  }

  Future<void> login(String email, String password) async {
    Get.offAllNamed(Routes.SENIOR_PROFILE);
  }

  Future<void> resetPassword(String email) async {
    Get.snackbar('Password Reset', 'Reset link sent to $email');
  }

  Future<void> setNewPassword(String newPassword) async {
    Get.snackbar('Success', 'Password updated successfully.');
    Get.offAllNamed(Routes.AUTH);
  }

  Future<void> updateUserRoleAndNavigate(String role) async {
    if (role == 'caregiver') {
      Get.offAllNamed(Routes.CAREGIVER_DASHBOARD);
    } else {
      Get.offAllNamed(Routes.SENIOR_PROFILE);
    }
  }

  Future<void> signInWithGoogle() async {
    Get.offAllNamed(Routes.SENIOR_PROFILE);
  }

  Future<void> signInWithFacebook() async {
    Get.offAllNamed(Routes.SENIOR_PROFILE);
  }

  Future<void> logout() async {
    Get.offAllNamed(Routes.AUTH);
  }
}
