import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nj_pizza_delivery/api/api_path.dart';
import 'package:nj_pizza_delivery/api/config.dart';
import 'package:nj_pizza_delivery/routes/app_routes.dart';
import 'package:nj_pizza_delivery/utils/auth_service.dart';

import '../../home/myFavourite/controller/my_favourite_controller.dart';
import '../../home/notification/controller/notification_controller.dart';
import '../../home/profile/controller/profile_controller.dart';

class LoginController extends GetxController with WidgetsBindingObserver {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  RxDouble imageTop = 0.0.obs;

  final isPasswordHidden = true.obs;
  final isLoading = false.obs;

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

  void _showError(String message) {
    Get.snackbar(
      "Error",
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(12),
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
    );
  }

  Future<void> login() async {
    if (isLoading.value) return;

    if (emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty) {
      _showError("Please enter email and password");
      return;
    }

    if (!GetUtils.isEmail(emailController.text.trim())) {
      _showError("Please enter a valid email address");
      return;
    }

    try {
      isLoading.value = true;

      final response = await Config.dio.post(
        '/${ApiPath.login}',
        data: {
          'email': emailController.text.trim(),
          'password': passwordController.text.trim(),
        },
      );

      final Map<String, dynamic> data =
          response.data is String
              ? jsonDecode(response.data)
              : Map<String, dynamic>.from(response.data);

      if (response.statusCode == 200 && data['success'] == true) {
        final user = data['user'];

        await AuthService.saveLogin(
          userId: user['id'],
          name: user['name'],
          email: user['email'],
          token: data['token'],
          expiresAt: data['expires_at'],
        );

        _showSuccess("Login successful");
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.delete<ProfileController>(force: true);
          Get.delete<NotificationController>(force: true);
          Get.delete<FavoritesController>(force: true);
          Get.put(NotificationController(), permanent: true);
          Get.offAllNamed(Routes.HOME);
        });
        return;
      }

      _showError(data['message'] ?? "Login failed");
    } catch (e) {
      debugPrint('❌ LOGIN ERROR: $e');
      _showError("Server error. Please try again.");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    scrollController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
