import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPasswordController extends GetxController {
  final emailController = TextEditingController();

  void sendResetLink() {
    if (emailController.text.isEmpty ||
        !emailController.text.contains("@") ||
        !emailController.text.contains(".")) {
      Get.snackbar("Error", "Please enter a valid email address");
      return;
    }

    // Simulate sending link
    Get.snackbar(
      "Success",
      "Password reset link sent to ${emailController.text}",
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
