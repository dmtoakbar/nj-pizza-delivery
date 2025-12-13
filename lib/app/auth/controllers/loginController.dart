import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var isPasswordHidden = true.obs;

  void login() {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar("Error", "Please enter email and password");
      return;
    }

    Get.snackbar("Success", "Login successful");
  }
}
