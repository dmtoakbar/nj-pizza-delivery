import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nj_pizza_delivery/app/home/cart/controller/cart_controller.dart';
import 'package:nj_pizza_delivery/constants/app_strings.dart';
import 'package:nj_pizza_delivery/constants/images_files.dart';
import 'package:nj_pizza_delivery/utils/auth_service.dart';
import '../../../../routes/app_routes.dart';
import '../../notification/controller/notification_controller.dart';
import '../../notification/model/notification_model.dart';
import '../../notification/notification_panel.dart';
import '../../profile/controller/profile_controller.dart';

class Header extends StatelessWidget {
  const Header({super.key});
  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();
    RxBool isLoggedIn = false.obs;
    void checkLogin() async {
      isLoggedIn.value = await AuthService.isLoggedIn();
    }

    String formatAddress(String address, {int maxLength = 25}) {
      if (address.length <= maxLength) return address;

      int partLength = (maxLength - 3) ~/ 2;

      String start = address.substring(0, partLength);
      String end = address.substring(address.length - partLength);

      return "$start...$end";
    }

    checkLogin();
    final ProfileController profile = Get.find<ProfileController>();
    return Obx(
      () => Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 3.0),
            child: Builder(
              builder:
                  (context) => GestureDetector(
                    onTap: () {
                      Scaffold.of(context).openDrawer(); // 💥 Opens Drawer
                    },
                    child: Icon(Icons.menu, size: 36, color: Colors.black),
                  ),
            ),
          ),
          // const CircleAvatar(
          //   radius: 22,
          //   backgroundColor: Color(0xFFF2F2F2),
          //   child: Icon(Icons.person, color: Colors.black54),
          // ),
          const SizedBox(width: 12),
          if (!isLoggedIn.value)
            Text(
              AppStrings.appName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          if (isLoggedIn.value)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formatAddress(profile.name.value, maxLength: 22),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 2),
                Row(
                  children: [
                    Image.asset(
                      ImagesFiles.locationIcon,
                      height: 14,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 4),
                    Text(
                      formatAddress(profile.address.value),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),

          const Spacer(),
          Row(
            children: [
              Obx(() {
                final count = cart.items.length;

                return TweenAnimationBuilder<double>(
                  key: ValueKey(count), // 🔥 detects cart change
                  tween: Tween(begin: 0.85, end: 1.0),
                  duration: const Duration(milliseconds: 240),
                  curve: Curves.easeOut,
                  builder: (_, scale, child) {
                    return Transform.scale(scale: scale, child: child);
                  },
                  child: GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.CART);
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Image.asset(
                          ImagesFiles.shoppingBag,
                          height: 23,
                          color: Colors.black,
                        ),

                        /// 🔴 CART COUNT
                        Positioned(
                          top: -9,
                          right: -4,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              color: Color(0xFFEB5525),
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              count > 99 ? '99+' : '$count',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
          _notificationIcon(),
        ],
      ),
    );
  }
}

Widget _notificationIcon() {
  final controller = Get.find<NotificationController>();

  return Obx(() {
    return GestureDetector(
      onTap: openNotificationPanel,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 1),
            child: Icon(Icons.notifications_none, size: 24),
          ),
          if (controller.unreadCount.value > 0)
            Positioned(
              right: -2,
              top: -7,
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Color(0xFFEB5525),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  controller.unreadCount.value > 99
                      ? '99+'
                      : controller.unreadCount.value.toString(),
                  style: TextStyle(color: Colors.white, fontSize: 8),
                ),
              ),
            ),
        ],
      ),
    );
  });
}
