import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nj_pizza_delivery/routes/app_routes.dart';

class RegistrationController extends GetxController {
  // ───────────── Text Controllers ─────────────
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // ───────────── UI State ─────────────
  RxBool isPasswordHidden = true.obs;
  RxBool isConfirmPasswordHidden = true.obs;
  final isLoading = false.obs;

  // ───────────── Firebase ─────────────
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  // ───────────── Register Method ─────────────
  Future<void> register() async {
    // Empty fields check
    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        addressController.text.trim().isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      _showError("Please fill all fields");
      return;
    }

    // Email validation
    if (!GetUtils.isEmail(emailController.text.trim())) {
      _showError("Please enter a valid email address");
      return;
    }

    // Phone validation (India – 10 digits)
    if (!RegExp(r'^[0-9]{10}$')
        .hasMatch(phoneController.text.trim())) {
      _showError("Please enter a valid 10-digit phone number");
      return;
    }

    // Password validation
    if (passwordController.text.length < 6) {
      _showError("Password must be at least 6 characters");
      return;
    }

    // Password match
    if (passwordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      _showError("Passwords do not match");
      return;
    }

    try {
      isLoading.value = true;

      // Firebase Auth
      final UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final String uid = userCredential.user!.uid;

      // Firestore
      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
        'address': addressController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      _showSuccess("Account created successfully");

      // Navigate to login
      Get.offNamed(Routes.LOGIN);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        _showError("Email already registered");
      } else if (e.code == 'weak-password') {
        _showError("Password should be at least 6 characters");
      } else {
        _showError(e.message ?? "Registration failed");
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
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}

