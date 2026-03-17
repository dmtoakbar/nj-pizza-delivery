import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nj_pizza_delivery/app/auth/widgets/app_text_field.dart';
import 'package:nj_pizza_delivery/app/auth/widgets/opt_input_box.dart';
import '../../constants/images_files.dart';
import 'controllers/verify_opt_and_update_password_controller.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});

  final String email = Get.arguments as String;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ResetPasswordController>();
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
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
                            const SizedBox(height: 20),

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

                            const SizedBox(height: 20),

                            /// Title (centered)
                            Text(
                              "Reset\nPassword",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF3E2723),
                                height: 1.2,
                              ),
                            ),

                            const SizedBox(height: 20),
                            Spacer(),

                            Text(
                              'OTP sent to $email',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade700,
                              ),
                            ),

                            // otp boxes
                            const SizedBox(height: 16),

                            OtpBoxInput(
                              onCompleted: (otp) {
                                controller.otpController.text = otp;
                              },
                            ),

                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed:
                                    controller.secondsLeft.value == 0
                                        ? controller.resendOtp
                                        : null,
                                child: Text(
                                  controller.secondsLeft.value == 0
                                      ? 'Resend OTP'
                                      : 'Resend in ${controller.secondsLeft.value}s',
                                  style: GoogleFonts.poppins(
                                    color: Colors.deepOrange,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 30),

                            /// Password Field
                            AppTextField(
                              controller: controller.passwordController,
                              hintText: "Password",
                              obscureText: true,
                            ),

                            const SizedBox(height: 30),

                            AppTextField(
                              controller: controller.confirmPasswordController,
                              hintText: "Confirm Password",
                              obscureText: true,
                            ),

                            const SizedBox(height: 30),

                            Spacer(),

                            /// Bottom Section (Fixed)
                            SizedBox(
                              height: 55,
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepOrange,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                onPressed:
                                    controller.isLoading.value
                                        ? null
                                        : controller.verifyAndReset,
                                child:
                                    controller.isLoading.value
                                        ? const SizedBox(
                                          height: 34,
                                          width: 34,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                        : Text(
                                          'Verify & Reset Password',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            color: Colors.white,
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
