import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData;
import 'package:dio/dio.dart';
import 'package:nj_pizza_delivery/api/api_path.dart';
import 'package:nj_pizza_delivery/constants/user_profile_data.dart';
import '../../../../api/config.dart';

class ReportController extends GetxController {
  final subjectController = TextEditingController();
  final orderIdController = TextEditingController();
  final messageController = TextEditingController();
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

  Future<void> submitReport() async {
    // ✅ Validation
    if (orderIdController.text.isEmpty ||
        subjectController.text.isEmpty ||
        messageController.text.isEmpty) {
      _showError("Please fill all required fields");
      return;
    }

    try {
      isSending.value = true;

      // ✅ Ensure user data is loaded
      if (!userProfileData.dataLoaded) {
        await userProfileData.getUserData();
      }

      // ✅ Form data
      final formData = FormData.fromMap({
        "name": userProfileData.name,
        "email": userProfileData.email,
        "phone": userProfileData.mobile,
        "address": userProfileData.address,
        "orderId": orderIdController.text.trim(),
        "issue": subjectController.text.trim(),
        "issueMessage": messageController.text.trim(),
      });

      // ✅ API call
      final response = await Config.dio.post(
        '/${ApiPath.reportIssue}',
        data: formData,
      );

      final Map<String, dynamic> data =
          response.data is String
              ? jsonDecode(response.data)
              : Map<String, dynamic>.from(response.data);

      if (response.statusCode == 200 && data['success'] == true) {
        _showSuccess(
          data['message'] ?? "Your report has been sent successfully!",
        );
        orderIdController.clear();
        subjectController.clear();
        messageController.clear();
      } else {
        _showError(data['message'] ?? "Something went wrong!");
      }
    } catch (e) {
      _showError("Something went wrong! ${e.toString()}");
    } finally {
      isSending.value = false;
    }
  }
}
