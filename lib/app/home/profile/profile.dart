import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nj_pizza_delivery/app/home/profile/controller/profile_controller.dart';
import 'package:nj_pizza_delivery/app/home/widgets/appBar/app_bar_widget.dart';

class ProfileScreen extends GetView<ProfileController> {
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
              // Profile Icon / Avatar
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.orange.shade100,
                ),
                child: const Icon(
                  Icons.person,
                  size: 70,
                  color: Colors.deepOrange,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Your Profile",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),

              const SizedBox(height: 35),

              // Name
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

              // Email (Non-editable)
              TextField(
                controller: controller.emailController,
                readOnly: true,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email_outlined),
                  labelText: "Email",
                  filled: true,
                  fillColor: Colors.white70,
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
                maxLines: 1,
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
              const SizedBox(height: 30),

              // Update Button
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
                  onPressed: controller.updateProfile,
                  child: const Text(
                    "Update Profile",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
