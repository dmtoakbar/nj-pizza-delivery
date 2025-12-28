import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:nj_pizza_delivery/app/home/profile/controller/profile_controller.dart';
import 'package:nj_pizza_delivery/routes/app_routes.dart';
import 'package:nj_pizza_delivery/utils/auth_service.dart';

class SideMenuWidget extends StatelessWidget {
  final ProfileController controller = Get.find<ProfileController>();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      backgroundColor: Colors.deepOrange,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.only(right: 12, top: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(Icons.close, size: 26, color: Colors.white),
                ),
              ],
            ),
          ),

          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Obx(() {
              if (controller.isProfileLoading.value) {
                return Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }

              return Row(
                children: [
                  Icon(Icons.person, size: 70, color: Colors.white),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.PROFILE);
                          },
                          child: Row(
                            children: [
                              Text(
                                controller.nameController.text,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(
                                Icons.edit_outlined,
                                size: 20,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          controller.phoneController.text,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),

          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Divider(color: Colors.white),
                ),

                GestureDetector(
                  onTap: () {
                    {
                      Navigator.of(context).pop();
                      Get.until((route) => route.settings.name == Routes.HOME);
                    }
                  },
                  child: _menuItem(Icons.home, 'Home'),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Divider(color: Colors.white),
                ),

                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    Get.toNamed(Routes.REFUNDPOLICY);
                  },
                  child: _menuItem(Icons.receipt_long, 'Refund Policy'),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Divider(color: Colors.white),
                ),

                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    Get.toNamed(Routes.REPORT);
                  },
                  child: _menuItem(Icons.report, 'Report'),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Divider(color: Colors.white),
                ),

                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    Get.toNamed(Routes.CONTACTUS);
                  },
                  child: _menuItem(Icons.help_outline, 'Contact'),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Divider(color: Colors.white),
                ),
                GestureDetector(
                  onTap: () async {
                    await AuthService.logout();
                  },
                  child: _menuItem(Icons.logout, 'Logout'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuItem(IconData icon, String title, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, size: 24, color: Colors.white),

      title: Row(
        children: [
          Text(title, style: TextStyle(fontSize: 16, color: Colors.white)),
        ],
      ),

      onTap: onTap,
    );
  }
}
