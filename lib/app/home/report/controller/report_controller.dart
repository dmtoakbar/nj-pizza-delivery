import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportController extends GetxController {
  final subjectController = TextEditingController();
  final orderIdController = TextEditingController();
  final messageController = TextEditingController();

  void submitReport() {
    if (subjectController.text.isEmpty ||
        messageController.text.isEmpty) {
      Get.snackbar("Error", "Please fill all required fields");
      return;
    }



    Get.snackbar(
      "Report Submitted",
      "We have received your report, our team will respond soon.",
    );
  }
}
