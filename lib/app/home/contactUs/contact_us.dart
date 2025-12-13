import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nj_pizza_delivery/app/home/widgets/appBar/app_bar_widget.dart';
import 'controller/contact_us_controller.dart';

class ContactUsScreen extends GetView<ContactUsController> {
  @override
  Widget build(BuildContext context) {
    final components = appBarBundle();
    return Scaffold(
      appBar: components.appBar,
      drawer: components.drawer,
      backgroundColor: const Color(0xFFFDFAF5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
          child: Column(
            children: [
              // Icon Container
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
              TextField(
                controller: controller.nameController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person_outline),
                  labelText: "Your Name",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // EMAIL
              TextField(
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                style: GoogleFonts.poppins(),
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
              const SizedBox(height: 20),

              // PHONE
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

              // MESSAGE
              TextField(
                controller: controller.messageController,
                maxLines: 5,
                style: GoogleFonts.poppins(),
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  labelText: "Your Message",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
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
                  onPressed: controller.sendMessage,
                  child: const Text(
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
    );
  }
}
