import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../emailService/send/contact_us.dart';

class ContactUsController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final messageController = TextEditingController();
  final subjectController = TextEditingController();

  RxBool isSending = false.obs;

  void _showError(String message) {
    Get.snackbar(
      "Error",
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(12),
      icon: const Icon(Icons.error_outline, color: Colors.white),
    );
  }

  void _showSuccess(String message) {
    Get.snackbar(
      "Success",
      message,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(12),
      icon: const Icon(Icons.check_circle_outline, color: Colors.white),
    );
  }

  void sendMessage() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        messageController.text.isEmpty ||
        phoneController.text.isEmpty ||
        subjectController.text.isEmpty) {
      _showError("Please fill all required fields");
      return;
    }

    if (phoneController.text.length < 10) {
      _showError("Please enter valid phone number");
      return;
    }

    try {
      isSending.value = true;
      bool status = await sendContactUsToAdmin(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        subject: subjectController.text.trim(),
        query: messageController.text.trim(),
        address: '',
      );
      if (status) {
        _showSuccess("Your message has been sent successfully!");
        nameController.clear();
        emailController.clear();
        phoneController.clear();
        subjectController.clear();
        messageController.clear();
      } else {
        _showError("Something went wrong!");
      }
    } catch (e) {
      _showError("Something went wrong!");
    } finally {
      isSending.value = false;
    }
  }
}
