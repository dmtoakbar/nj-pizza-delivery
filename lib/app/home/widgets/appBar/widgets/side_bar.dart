import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:nj_pizza_delivery/app/home/profile/controller/profile_controller.dart';
import 'package:nj_pizza_delivery/constants/app_strings.dart';
import 'package:nj_pizza_delivery/routes/app_routes.dart';
import 'package:nj_pizza_delivery/utils/auth_service.dart';

class SideMenuWidget extends StatelessWidget {
  SideMenuWidget({super.key});

  final ProfileController controller = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: false,
      child: Drawer(
        elevation: 0,
        backgroundColor: Colors.deepOrange,
        child: FutureBuilder<bool>(
          future: AuthService.isLoggedIn(),
          builder: (context, snapshot) {
            final isLoggedIn = snapshot.data ?? false;
            return _buildDrawerContent(context, isLoggedIn);
          },
        ),
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

  Widget _policyMenuItem({
    required IconData icon,
    required String title,
    required String route,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
        Get.toNamed(route);
      },
      child: _menuItem(icon, title),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Logout",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.deepOrange,
          ),
        ),
        content: const Text(
          "Are you sure you want to logout?",
          style: TextStyle(fontSize: 15),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // close dialog
            },
            child: const Text("Cancel", style: TextStyle(color: Colors.black)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () async {
              Get.back(); // close dialog
              await AuthService.logout();
            },
            child: const Text("Logout", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  String formatAddress(String address, {int maxLength = 25}) {
    if (address.length <= maxLength) return address;

    int partLength = (maxLength - 3) ~/ 2;

    String start = address.substring(0, partLength);
    String end = address.substring(address.length - partLength);

    return "$start...$end";
  }

  Widget _buildDrawerContent(BuildContext context, bool isLoggedIn) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                        onTap:
                            isLoggedIn
                                ? () {
                                  Get.toNamed(Routes.PROFILE);
                                }
                                : () {},
                        child: Row(
                          children: [
                            Text(
                              isLoggedIn
                                  ? formatAddress(controller.nameController.text, maxLength: 15)
                                  : AppStrings.appName,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 4),
                            if (isLoggedIn) Icon(
                                Icons.edit_outlined,
                                size: 20,
                                color: Colors.white,
                              ),
                          ],
                        ),
                      ),
                      Text(
                        isLoggedIn
                            ? controller.phoneController.text
                            : '9XX....0',
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
                onTap:
                    isLoggedIn
                        ? () {
                          Navigator.of(context).pop();
                          Get.toNamed(Routes.REPORT);
                        }
                        : () {
                          Navigator.of(context).pop(); // close drawer first
                          AuthService.checkLoginAndRedirect();
                        },
                child: _menuItem(Icons.report, 'Report'),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Divider(color: Colors.white),
              ),

              GestureDetector(
                onTap:
                    isLoggedIn
                        ? () {
                          Navigator.of(context).pop();
                          Get.toNamed(Routes.CONTACTUS);
                        }
                        : () {
                          Navigator.of(context).pop(); // close drawer first
                          AuthService.checkLoginAndRedirect();
                        },
                child: _menuItem(Icons.help_outline, 'Contact'),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Divider(color: Colors.white),
              ),

              // ================= POLICIES =================
              _policyMenuItem(
                context: context,
                icon: Icons.receipt_long,
                title: 'Refund Policy',
                route: Routes.REFUNDPOLICY,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Divider(color: Colors.white),
              ),

              _policyMenuItem(
                context: context,
                icon: Icons.privacy_tip_outlined, // 🔒 Privacy
                title: 'Privacy Policy',
                route: Routes.PRIVACY_POLICY,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Divider(color: Colors.white),
              ),

              _policyMenuItem(
                context: context,
                icon: Icons.description_outlined, // 📄 Terms
                title: 'Terms & Conditions',
                route: Routes.TERMS,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Divider(color: Colors.white),
              ),

              _policyMenuItem(
                context: context,
                icon: Icons.local_shipping_outlined, // 🚚 Shipping
                title: 'Shipping Policy',
                route: Routes.SHIPPING_POLICY,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Divider(color: Colors.white),
              ),

              _policyMenuItem(
                context: context,
                icon: Icons.cancel_outlined, // ❌ Cancellation
                title: 'Cancellation Policy',
                route: Routes.CANCELLATION_POLICY,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Divider(color: Colors.white),
              ),

              _policyMenuItem(
                context: context,
                icon: Icons.info_outline, // ℹ️ About
                title: 'About Us',
                route: Routes.ABOUT_US,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Divider(color: Colors.white),
              ),

              _policyMenuItem(
                context: context,
                icon: Icons.help_outline, // ❓ FAQ
                title: 'FAQ',
                route: Routes.FAQ,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Divider(color: Colors.white),
              ),
              if (isLoggedIn)
                GestureDetector(
                  onTap: () async {
                    _showLogoutDialog(context);
                  },
                  child: _menuItem(Icons.logout, 'Logout'),
                ),

              if (isLoggedIn)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Divider(color: Colors.white),
                ),

              SizedBox(height: 50),
            ],
          ),
        ),
      ],
    );
  }
}
