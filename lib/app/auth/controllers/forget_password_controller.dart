import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nj_pizza_delivery/api/api_path.dart';
import '../../../api/config.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/app_toast.dart';
import '../verify_opt_and_update_password.dart';

class ForgetPasswordController extends GetxController with WidgetsBindingObserver {
  // ───────────── Text Controller ─────────────
  final emailController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  RxDouble imageTop = 0.0.obs;

  // ───────────── UI State ─────────────
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

  // ───────────── Send OTP for Reset ─────────────
  Future<void> sendResetOtp() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      AppToast.error("Please enter your email address");
      return;
    }

    if (!GetUtils.isEmail(email)) {
      AppToast.error("Please enter a valid email address");
      return;
    }

    if (isLoading.value) return;

    try {
      isLoading.value = true;

      final response = await Config.dio.post(
        '/${ApiPath.sentResetPasswordOtp}',
        data: {'email': email},
      );

      final data =
          response.data is String ? jsonDecode(response.data) : response.data;

      if (response.statusCode == 200 && data['success'] == true) {
        AppToast.success("OTP sent to $email");

        // ➡️ Navigate to OTP screen
        Get.toNamed(Routes.RESETPASSWORD, arguments: email);
        return;
      }

      AppToast.error(data['message'] ?? "Failed to send OTP");
    } catch (e) {
      AppToast.error("Server error. Please try again.");
    } finally {
      isLoading.value = false;
    }
  }

  // ───────────── Dispose ─────────────
  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    scrollController.dispose();
    emailController.dispose();
    super.onClose();
  }
}
