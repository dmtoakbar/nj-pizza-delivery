import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final nameController = TextEditingController(text: "John Doe");
  final emailController = TextEditingController(text: "john@example.com");
  final phoneController = TextEditingController(text: "+91 9876543210");
  final addressController = TextEditingController(text: "123 Pizza Street, NY");

  void updateProfile() {
    // Validation
    if (nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        addressController.text.isEmpty) {
      Get.snackbar("Error", "Please fill all fields");
      return;
    }

    // Simulate API call or save locally
    Get.snackbar(
      "Success",
      "Profile updated successfully",
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
