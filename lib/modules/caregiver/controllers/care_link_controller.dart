import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sahaara/app/routes/app_routes.dart';

class CareLinkController extends GetxController {
  var isLoading = false.obs;
  final careIdController = TextEditingController();

  Future<void> linkToReceiver() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 500));
    isLoading.value = false;
    Get.snackbar('Linked', 'Connected to senior care receiver ${careIdController.text}');
    Get.offAllNamed(Routes.CAREGIVER_DASHBOARD);
  }

  Future<void> linkCareReceiver(String code) async {
    careIdController.text = code;
    await linkToReceiver();
  }

  @override
  void onClose() {
    careIdController.dispose();
    super.onClose();
  }
}
