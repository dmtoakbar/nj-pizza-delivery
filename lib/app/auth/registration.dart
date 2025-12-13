import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'controllers/registrationController.dart';

class PizzaRegistrationScreen extends GetView<RegistrationController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFAF5),
      body: SafeArea(
        child: Center(
          child: Obx(
            () => SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),

                  // Pizza Logo
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
                    "Create Your Pizza Account",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Sign up to order your favorite pizzas!",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 35),

                  // Full Name
                  TextField(
                    controller: controller.nameController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_outline),
                      labelText: "Full Name",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Email
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

                  // Phone
                  TextField(
                    controller: controller.phoneController,
                    keyboardType: TextInputType.phone,
                    style: GoogleFonts.poppins(),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.phone_android),
                      labelText: "Phone Number",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Address
                  TextField(
                    controller: controller.addressController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.location_on_outlined),
                      labelText: "Delivery Address",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Password
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

                  const SizedBox(height: 20),

                  // Password
                  TextField(
                    controller: controller.confirmPassword,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_outline),
                      labelText: "Confirm Password",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          controller.cisPasswordHidden.value =
                              !controller.cisPasswordHidden.value;
                        },
                        icon: Icon(
                          controller.cisPasswordHidden.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Register Button
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
                      onPressed: controller.register,
                      child: const Text(
                        "Create Account",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account? "),
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: const Text(
                          "Login",
                          style: TextStyle(color: Colors.deepOrange),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
