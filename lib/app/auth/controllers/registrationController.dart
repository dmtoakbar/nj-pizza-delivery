import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegistrationController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPassword = TextEditingController();
  final isPasswordHidden = true.obs;
  final passwordError = "".obs;

  final cisPasswordHidden = true.obs;
  final cpasswordError = "".obs;

  void register() {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneController.text.length < 10 ||
        addressController.text.isEmpty ||
        passwordController.text.length < 6) {
      Get.snackbar("Error", "Please fill all details correctly");
      return;
    }

    Get.snackbar("Success", "Account Created Successfully");
  }
}
