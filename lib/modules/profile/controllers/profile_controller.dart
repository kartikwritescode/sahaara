import 'package:get/get.dart';
import '../views/edit_profile_screen.dart';
import '../views/linked_users_screen.dart';
import '../views/help_support_screen.dart';
import '../views/policies_screen.dart';
import 'package:sahaara/app/routes/app_routes.dart';

class ProfileController extends GetxController {
  var isLoading = false.obs;
  var isUploading = false.obs;

  Future<void> refreshProfile() async {
    // Refresh user profile logic
  }

  void onEditProfileTap() {
    Get.to(() => EditProfileScreen());
  }

  void onLinkedTap() {
    Get.to(() => LinkedUsersScreen());
  }

  void onPrivacyTap() {
    Get.to(() => PoliciesScreen());
  }

  void onHelpTap() {
    Get.to(() => HelpSupportScreen());
  }

  void onLogoutTap() {
    Get.offAllNamed(Routes.AUTH);
  }

  void editProfileScreenNav() => onEditProfileTap();
  void linkedUsersScreenNav() => onLinkedTap();
  void helpSupportScreenNav() => onHelpTap();

  void editProfileScreen() => onEditProfileTap();
  void linkedUsersScreen() => onLinkedTap();
  void helpSupportScreen() => onHelpTap();
}
