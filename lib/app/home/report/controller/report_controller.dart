import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nj_pizza_delivery/constants/user_profile_data.dart';
import 'package:nj_pizza_delivery/emailService/send/report_issue.dart';

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
    if (subjectController.text.isEmpty ||
        messageController.text.isEmpty ||
        messageController.text.isEmpty) {
      _showError("Please fill all required fields");
      return;
    }

    try {
      isSending.value = true;
      userProfileData.dataLoaded ? null : await userProfileData.getUserData();
      bool status = await sendOrderIssueToAdmin(
        name: userProfileData.name,
        email: userProfileData.email,
        phone: userProfileData.mobile,
        address: userProfileData.address,
        orderId: orderIdController.text.trim(),
        issue: subjectController.text.trim(),
        issueMessage: messageController.text.trim(),
      );
      if (status) {
        _showSuccess("Your query has been sent successfully!");
        orderIdController.clear();
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
