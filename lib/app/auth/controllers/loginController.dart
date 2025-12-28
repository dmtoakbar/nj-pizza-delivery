import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nj_pizza_delivery/routes/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nj_pizza_delivery/utils/auth_service.dart';

class LoginController extends GetxController {
  // ───────────── Text Controllers ─────────────
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // ───────────── UI State ─────────────
  final isPasswordHidden = true.obs;
  final isLoading = false.obs;

  // ───────────── Firebase ─────────────
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

  // ───────────── Login Method ─────────────
  Future<void> login() async {
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

      final auth = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (auth.user == null) {
        _showError("Login failed");
        return;
      }

      await AuthService.saveLogin(
        uid: auth.user!.uid,
        email: auth.user!.email!,
      );

      _showSuccess("Login successful");

      // Navigate to home / pizza slider
      Get.offAllNamed(Routes.HOME);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _showError("No account found with this email");
      } else if (e.code == 'wrong-password') {
        _showError("Incorrect password");
      } else {
        _showError(e.message ?? "Login failed");
      }
    } catch (e) {
      _showError("Something went wrong. Try again");
    } finally {
      isLoading.value = false;
    }
  }

  // ───────────── Dispose Controllers ─────────────
  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
