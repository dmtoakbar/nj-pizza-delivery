import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nj_pizza_delivery/app/auth/widgets/app_text_field.dart';
import '../widgets/headerWithBackButton/header_with_back_button.dart';
import 'controller/contact_us_controller.dart';

class ContactUsScreen extends GetView<ContactUsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 8),
            CustomHeader(title: 'Contact us', showCart: true),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 10,
                ),
                child: Obx(
                  () => Column(
                    children: [
                      SizedBox(height: 10),
                      Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.orange.shade100,
                        ),
                        child: const Icon(
                          Icons.support_agent_outlined,
                          size: 70,
                          color: Colors.deepOrange,
                        ),
                      ),
                      const SizedBox(height: 20),

                      const Text(
                        "Contact Us",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                        ),
                      ),
                      const SizedBox(height: 35),

                      // FULL NAME
                      AppTextField(
                        controller: controller.nameController,
                        hintText: "Your Name",
                      ),
                      const SizedBox(height: 20),

                      // EMAIL
                      AppTextField(
                        controller: controller.emailController,
                        keyboardType: TextInputType.emailAddress,
                        hintText: "Email Address",
                      ),
                      const SizedBox(height: 20),

                      // PHONE
                      AppTextField(
                        controller: controller.phoneController,
                        keyboardType: TextInputType.phone,
                        hintText: "Phone Number",
                      ),
                      const SizedBox(height: 20),

                      AppTextField(
                        controller: controller.subjectController,
                        hintText: "Enter subject",
                      ),

                      const SizedBox(height: 20),

                      // MESSAGE
                      AppTextField(
                        controller: controller.messageController,
                        maxLines: 5,
                        hintText: "Your Message",
                      ),

                      const SizedBox(height: 30),

                      // SEND BUTTON
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
                          onPressed:
                              controller.isSending.value
                                  ? null
                                  : controller.sendMessage,
                          child:
                              controller.isSending.value
                                  ? Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                  : const Text(
                                    "Send Message",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
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
