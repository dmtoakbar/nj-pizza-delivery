import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgetPasswordController extends GetxController {
  // ───────────── Text Controller ─────────────
  final emailController = TextEditingController();

  // ───────────── UI State ─────────────
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

  // ───────────── Send Reset Link ─────────────
  Future<void> sendResetLink() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      _showError("Please enter your email address");
      return;
    }

    if (!GetUtils.isEmail(email)) {
      _showError("Please enter a valid email address");
      return;
    }

    try {
      isLoading.value = true;

      final querySnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .where('email', isEqualTo: email)
              .get();

      if (querySnapshot.docs.isEmpty) {
        // No user found
        Get.snackbar(
          "Error",
          "No account found with this email",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // 🔹 Send password reset email
      await _auth.sendPasswordResetEmail(email: email);

      _showSuccess("Password reset link sent to $email");
    } on FirebaseAuthException catch (e) {
      _showError(e.message ?? "Failed to send reset link");
    } catch (e) {
      _showError("Something went wrong. Try again");
    } finally {
      isLoading.value = false;
    }
  }

  // ───────────── Dispose ─────────────
  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
