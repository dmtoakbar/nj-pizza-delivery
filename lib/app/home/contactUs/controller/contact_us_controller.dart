import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactUsController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final messageController = TextEditingController();

  void sendMessage() {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        messageController.text.isEmpty) {
      Get.snackbar("Error", "Please fill all required fields");
      return;
    }


    Get.snackbar("Success", "Your message has been sent successfully!");
  }
}
