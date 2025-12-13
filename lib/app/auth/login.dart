import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nj_pizza_delivery/routes/app_routes.dart';
import 'controllers/loginController.dart';

class PizzaLoginScreen extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFAF5),
      body: SafeArea(
        child: Center(
          child: Obx(() => SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                // Pizza Logo
                Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.orange.shade100,
                  ),
                  child: const Icon(
                    Icons.local_pizza,
                    size: 70,
                    color: Colors.deepOrange,
                  ),
                ),

                const SizedBox(height: 20),

                // Title
                const Text(
                  "Welcome to Pizza Hub",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  "Order delicious pizzas in one tap",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 35),

                // Email Field (Gradient Border)
                TextField(
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email_outlined),
                    labelText: "Email",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Password Field (Gradient Border)
                TextField(
                  controller: controller.passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline),
                    labelText: "Password",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        controller.isPasswordHidden.value =
                        !controller.isPasswordHidden.value;
                      },
                      icon: Icon(
                        controller.isPasswordHidden.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.black,
                      ),
                    ),
                  ),

                ),

                const SizedBox(height: 30),

                // Login Button
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
                    onPressed: controller.login,
                    child: const Text(
                      "Login",
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
                  onPressed: () {
                    Get.toNamed(Routes.FORGETPASSWORD);
                  },
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(color: Colors.deepOrange, fontSize: 15),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.REGISTRATION);
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(color: Colors.deepOrange),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
        ),
      ),
    );
  }
}
