import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../api/api_path.dart';
import '../../../api/config.dart';
import '../../../utils/app_toast.dart';

class ResetPasswordController extends GetxController with WidgetsBindingObserver {
  final String email;

  ResetPasswordController(this.email);
  final ScrollController scrollController = ScrollController();
  RxDouble imageTop = 0.0.obs;

  final otpController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  RxBool isPasswordHidden = true.obs;
  RxBool isConfirmPasswordHidden = true.obs;

  final isLoading = false.obs;
  final secondsLeft = 60.obs;
  Timer? _timer;

  @override
  void onInit() {
    WidgetsBinding.instance.addObserver(this);
    startTimer();
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

  // ───────── Timer ─────────
  void startTimer() {
    secondsLeft.value = 60;
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsLeft.value == 0) {
        timer.cancel();
      } else {
        secondsLeft.value--;
      }
    });
  }

  // ───────── Resend OTP ─────────
  Future<void> resendOtp() async {
    if (secondsLeft.value > 0) return;

    try {
      isLoading.value = true;

      final response = await Config.dio.post(
        '/${ApiPath.sentResetPasswordOtp}',
        data: {'email': email},
      );

      final data =
          response.data is String ? jsonDecode(response.data) : response.data;

      if (response.statusCode == 200 && data['success'] == true) {
        AppToast.success('OTP resent to email');
        startTimer();
      } else {
        AppToast.error(data['message'] ?? 'Failed to resend OTP');
      }
    } catch (e) {
      AppToast.error('Server error');
    } finally {
      isLoading.value = false;
    }
  }

  // ───────── Verify OTP + Reset Password ─────────
  Future<void> verifyAndReset() async {
    if (isLoading.value) return;
    if (otpController.text.length != 6) {
      AppToast.error('Enter valid 6-digit OTP');
      return;
    }

    if (passwordController.text.length < 6) {
      AppToast.error('Password must be at least 6 characters');
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      AppToast.error('Passwords do not match');
      return;
    }

    try {
      isLoading.value = true;

      final response = await Config.dio.post(
        '/${ApiPath.verifyOtpAndUpdatePassword}',
        data: {
          'email': email,
          'otp': otpController.text.trim(),
          'new_password': passwordController.text.trim(),
        },
      );

      final data =
          response.data is String ? jsonDecode(response.data) : response.data;

      if (response.statusCode == 200 && data['success'] == true) {
        AppToast.success('Password updated successfully');
        Get.offNamed('/login');
        return;
      }

      AppToast.error(data['message'] ?? 'Invalid OTP');
    } catch (e) {
      AppToast.error('Server error');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    scrollController.dispose();
    _timer?.cancel();
    otpController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
