import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData;
import 'package:nj_pizza_delivery/routes/app_routes.dart';

import '../../../api/config.dart';

class RegistrationController extends GetxController with WidgetsBindingObserver {
  // ───────────── Text Controllers ─────────────
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  RxDouble imageTop = 0.0.obs;

  @override
  void onInit() {
    WidgetsBinding.instance.addObserver(this);
    scrollController.addListener(() {
      imageTop.value = scrollController.offset;
    });
    super.onInit();
  }

  @override
  void didChangeMetrics() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        imageTop.value = scrollController.offset;
      }
    });
  }

  // ───────────── UI State ─────────────
  RxBool isPasswordHidden = true.obs;
  RxBool isConfirmPasswordHidden = true.obs;
  final isLoading = false.obs;

  // ───────────── Snackbars ─────────────
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

  //───────────── Register via API ─────────────
  Future<void> register() async {
    // Validation
    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        addressController.text.trim().isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      _showError("Please fill all fields");
      return;
    }

    if (!GetUtils.isEmail(emailController.text.trim())) {
      _showError("Please enter a valid email address");
      return;
    }

    if (!RegExp(r'^[0-9]{10}$').hasMatch(phoneController.text.trim())) {
      _showError("Please enter a valid 10-digit phone number");
      return;
    }

    if (passwordController.text.length < 6) {
      _showError("Password must be at least 6 characters");
      return;
    }

    if (passwordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      _showError("Passwords do not match");
      return;
    }

    try {
      isLoading.value = true;
      final formData = FormData.fromMap({
        'name': nameController.text.trim(),
        'phone': phoneController.text.trim(),
        'address': addressController.text.trim(),
        'email': emailController.text.trim(),
        'password': passwordController.text.trim(),
      });

      final response = await Config.dio.post('/auth/register', data: formData);

      final Map<String, dynamic> data =
      response.data is String
          ? jsonDecode(response.data)
          : Map<String, dynamic>.from(response.data);

      if (response.statusCode == 200 && data['success'] == true) {
        _showSuccess("Account created successfully");
        Get.offNamed(Routes.LOGIN);
        return;
      } else {
        _showError(data['message'] ?? "Registration failed");
      }
    } catch (e) {
      _showError("Server error. Please try again.");
    } finally {
      isLoading.value = false;
    }
  }

  // ───────────── Dispose ─────────────
  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    scrollController.dispose();
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
