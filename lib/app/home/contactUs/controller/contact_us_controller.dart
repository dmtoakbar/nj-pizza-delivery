import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData;
import 'package:nj_pizza_delivery/api/api_path.dart';
import '../../../../api/config.dart';
import 'package:dio/dio.dart';

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
      final formData = FormData.fromMap({
        'name': nameController.text.trim(),
        'phone': phoneController.text.trim(),
        'subject': subjectController.text.trim(),
        'email': emailController.text.trim(),
        'message': messageController.text.trim(),
      });
      final response = await Config.dio.post(
        '/${ApiPath.contactUs}',
        data: formData,
      );
      final Map<String, dynamic> data =
          response.data is String
              ? jsonDecode(response.data)
              : Map<String, dynamic>.from(response.data);

      if (response.statusCode == 200 && data['success'] == true) {
        _showSuccess("Your message has been sent successfully!");
        nameController.clear();
        emailController.clear();
        phoneController.clear();
        subjectController.clear();
        messageController.clear();
        return;
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
