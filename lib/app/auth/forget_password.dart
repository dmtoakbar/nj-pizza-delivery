import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nj_pizza_delivery/app/auth/controllers/forget_password_controller.dart';

class ForgetPasswordScreen extends GetView<ForgetPasswordController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFAF5),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                // Pizza Icon
                Container(
                  height: 110,
                  width: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.orange.shade100,
                  ),
                  child: const Icon(
                    Icons.local_pizza,
                    size: 65,
                    color: Colors.deepOrange,
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Forgot Password?",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "Enter your email and we’ll send you a reset link.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),

                const SizedBox(height: 35),

                // Email Field (Gradient Border)
                _gradientBorderField(
                  child: TextField(
                    controller: controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email_outlined),
                      labelText: "Email Address",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Send Reset Link Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: controller.sendResetLink,
                    child: const Text(
                      "Send Reset Link",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text(
                    "Back to Login",
                    style: TextStyle(
                      color: Colors.deepOrange,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Gradient Border Wrapper ---
  Widget _gradientBorderField({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          colors: [Colors.deepOrange, Colors.orange],
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: child,
      ),
    );
  }
}
