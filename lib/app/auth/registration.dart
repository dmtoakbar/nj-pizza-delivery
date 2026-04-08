import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nj_pizza_delivery/app/auth/widgets/app_text_field.dart';
import 'package:nj_pizza_delivery/routes/app_routes.dart';
import '../../constants/images_files.dart';
import 'controllers/registrationController.dart';

class PizzaRegistrationScreen extends GetView<RegistrationController> {
  const PizzaRegistrationScreen({super.key});

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
                            "Create\nAccount",
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
                          AppTextField(
                            controller: controller.nameController,
                            hintText: "Full Name",
                            keyboardType: TextInputType.text,
                          ),

                          const SizedBox(height: 30),

                          /// Email Field
                          AppTextField(
                            controller: controller.emailController,
                            hintText: "Email",
                            keyboardType: TextInputType.emailAddress,
                          ),

                          const SizedBox(height: 30),

                          /// Email Field
                          AppTextField(
                            controller: controller.phoneController,
                            hintText: "Phone Number",
                            keyboardType: TextInputType.phone,
                          ),

                          const SizedBox(height: 30),

                          AppTextField(
                            controller: controller.addressController,
                            hintText: "Delivery Address",
                            keyboardType: TextInputType.streetAddress,
                          ),

                          const SizedBox(height: 30),

                          /// Password Field
                         Obx(() =>  AppTextField(
                           controller: controller.passwordController,
                           hintText: "Password",
                           obscureText: controller.isPasswordHidden.value ? true : false,
                           suffixIcon: IconButton(
                             onPressed: () {
                               controller.isPasswordHidden.value =
                               !controller.isPasswordHidden.value;
                             },
                             icon: Icon(
                               controller.isPasswordHidden.value
                                   ? Icons.visibility_off
                                   : Icons.visibility,
                               color: Color(0xFFEB5525),
                             ),
                           ),
                         )),

                          const SizedBox(height: 30),

                          Obx(() => AppTextField(
                            controller: controller.confirmPasswordController,
                            hintText: "Confirm Password",
                            obscureText: controller.isConfirmPasswordHidden.value ? true : false,
                            suffixIcon: IconButton(
                              onPressed: () {
                                controller.isConfirmPasswordHidden.value =
                                !controller.isConfirmPasswordHidden.value;
                              },
                              icon: Icon(
                                controller.isConfirmPasswordHidden.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Color(0xFFEB5525),
                              ),
                            ),
                          )),

                          Spacer(),

                          const SizedBox(height: 50),

                          /// Bottom Section (Fixed)
                          Obx(
                            () => GestureDetector(
                              onTap:
                                  controller.isLoading.value
                                      ? null
                                      : controller.register,
                              child: Container(
                                height: 55,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFFF6B3D),
                                      Color(0xFFEB5525),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.deepOrange.withOpacity(0.4),
                                      blurRadius: 18,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
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
                                            "Create Account",
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
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
                                "Already have an account? ",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Get.toNamed(Routes.LOGIN),
                                child: const Text(
                                  "Sign In",
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
