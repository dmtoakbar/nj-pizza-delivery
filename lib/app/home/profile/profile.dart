import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nj_pizza_delivery/app/auth/widgets/app_text_field.dart';
import 'package:nj_pizza_delivery/app/home/profile/controller/profile_controller.dart';
import 'package:nj_pizza_delivery/app/home/widgets/appBar/header.dart';
import '../../../routes/app_routes.dart';
import '../widgets/appBar/widgets/side_bar.dart';
import '../widgets/bottomAppBar/animated_bottom_nav.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final controller = Get.find<ProfileController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: SideMenuWidget(),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Header(),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: Obx(() {
                return controller.isProfileLoading.value
                    ? Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                    : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 10,
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 14),
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
                          AppTextField(
                            controller: controller.nameController,
                            hintText: "Full Name",
                            keyboardType: TextInputType.text,
                          ),

                          const SizedBox(height: 20),

                          AppTextField(
                            controller: controller.emailController,
                            hintText: "Email",
                            readOnly: true,
                          ),
                          // Email (Non-editable)
                          const SizedBox(height: 20),

                          // Phone
                          AppTextField(
                            controller: controller.phoneController,
                            hintText: "Phone Number",
                            keyboardType: TextInputType.phone,
                          ),

                          const SizedBox(height: 20),

                          // Address
                          AppTextField(
                            controller: controller.addressController,
                            hintText: "Delivery Address",
                            keyboardType: TextInputType.streetAddress,
                            readOnly: true,
                            autoExpandMaxLines: true,
                            onTap: () async {
                              FocusScope.of(context).unfocus();
                              final result = await Get.toNamed(
                                Routes.MAPSEARCHADDRESS,
                              );
                              if (result != null) {
                                controller.addressController.text = result;
                              }
                            },
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
                              onPressed:
                                  controller.isUpdating.value ||
                                          controller.isAccountDeleting.value
                                      ? null
                                      : controller.updateProfile,
                              child:
                                  controller.isUpdating.value
                                      ? Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      )
                                      : const Text(
                                        "Update Profile",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                            ),
                          ),

                          const SizedBox(height: 25),

                          // Delete Button
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
                                  controller.isUpdating.value ||
                                          controller.isAccountDeleting.value
                                      ? null
                                      : () {
                                        _showDeleteConfirmation(context);
                                      },
                              child:
                                  controller.isAccountDeleting.value
                                      ? Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      )
                                      : const Text(
                                        "Delete Account",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                            ),
                          ),
                          SizedBox(height: 40),
                        ],
                      ),
                    );
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AnimatedBottomNav(),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    Get.defaultDialog(
      title: "Delete Account",
      titleStyle: TextStyle(color: Colors.deepOrange),
      middleText:
          "Are you sure you want to delete your account?\nThis action cannot be undone.",

      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange),
        onPressed: () {
          Get.back();
          controller.deleteUser();
        },
        child: Text("Delete", style: TextStyle(color: Colors.white)),
      ),

      cancel: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
        onPressed: () {
          Get.back();
        },
        child: Text("Cancel", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
