import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nj_pizza_delivery/app/auth/widgets/app_text_field.dart';
import 'package:nj_pizza_delivery/constants/images_files.dart';
import 'package:nj_pizza_delivery/routes/app_routes.dart';
import 'controllers/loginController.dart';

class PizzaLoginScreen extends GetView<LoginController> {
  const PizzaLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Obx(
              () => Positioned(
                top: -controller.imageTop.value,
                right: 0,
                child: Image.asset(
                  ImagesFiles.authRightCornerImage,
                  height: 180,
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SingleChildScrollView(
                  controller: controller.scrollController,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight:
                          MediaQuery.of(context).size.height -
                          MediaQuery.of(context).padding.top,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 40),

                          /// Back Button (left aligned)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: InkWell(
                              onTap: () => Get.back(),
                              child: const Icon(
                                Icons.arrow_back_ios_new,
                                size: 24,
                                color: Color(0xFF3E2723),
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),

                          /// Title (centered)
                          Text(
                            "Welcome\nBack",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF3E2723),
                              height: 1.2,
                            ),
                          ),

                          const SizedBox(height: 30),
                          Spacer(),

                          /// Scrollable Content

                          /// Email Field
                          AppTextField(
                            controller: controller.emailController,
                            hintText: "Email",
                            keyboardType: TextInputType.emailAddress,
                          ),

                          const SizedBox(height: 30),

                          /// Password Field
                          AppTextField(
                            controller: controller.passwordController,
                            hintText: "Password",
                            obscureText: true,
                          ),

                          const SizedBox(height: 30),

                          Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap:
                                  controller.isLoading.value
                                      ? null
                                      : () =>
                                          Get.toNamed(Routes.FORGETPASSWORD),
                              child: Text(
                                "Forgot Password?",
                                style: GoogleFonts.poppins(
                                  color: Colors.deepOrange,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),

                          Spacer(),

                          /// Bottom Section (Fixed)
                          Obx(
                            () => GestureDetector(
                              onTap:
                                  controller.isLoading.value
                                      ? null
                                      : controller.login,
                              child: Container(
                                height: 55,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: Color(0xFFEB5525),
                                ),
                                child: Center(
                                  child:
                                      controller.isLoading.value
                                          ? const SizedBox(
                                            height: 34,
                                            width: 34,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2.5,
                                            ),
                                          )
                                          : Text(
                                            "Login",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),

                          /// Sign Up
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don’t have an account? ",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Get.toNamed(Routes.REGISTRATION),
                                child: const Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF3E2723),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
