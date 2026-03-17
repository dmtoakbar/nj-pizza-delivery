import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nj_pizza_delivery/app/auth/controllers/forget_password_controller.dart';
import 'package:nj_pizza_delivery/app/auth/widgets/app_text_field.dart';
import '../../constants/images_files.dart';

class ForgetPasswordScreen extends GetView<ForgetPasswordController> {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
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
                      child: Obx(
                        () => Column(
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
                              "Forgot\nPassword?",
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
                            Text(
                              "Enter your email and we’ll send you an OTP."
                              "Check spam folder if you don’t see it.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                              ),
                            ),

                            const SizedBox(height: 35),

                            /// Email Field
                            AppTextField(
                              controller: controller.emailController,
                              hintText: "Email",
                              keyboardType: TextInputType.emailAddress,
                            ),

                            const SizedBox(height: 30),

                            Spacer(),

                            /// Bottom Section (Fixed)
                            GestureDetector(
                              onTap:
                                  controller.isLoading.value
                                      ? null
                                      : controller.sendResetOtp,
                              child: Container(
                                height: 55,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFFF6B3D),
                                      Color(0xFFEB5525),
                                    ],
                                  ),
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
                                            "Send OTP",
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),

                            /// Sign Up
                            Align(
                              alignment: Alignment.center,
                              child: TextButton(
                                onPressed:
                                    controller.isLoading.value
                                        ? null
                                        : () => Get.back(),
                                child: Text(
                                  "Back to Login",
                                  style: GoogleFonts.poppins(
                                    color: Colors.deepOrange,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 30),
                          ],
                        ),
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
