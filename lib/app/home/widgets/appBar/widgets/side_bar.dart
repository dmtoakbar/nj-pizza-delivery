import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:nj_pizza_delivery/routes/app_routes.dart';

class SideMenuWidget extends StatelessWidget {
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
            child: Row(
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
                              'Json Jone',
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
                        '+918976543210',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
                    // await UniversalFunction.logout();
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
