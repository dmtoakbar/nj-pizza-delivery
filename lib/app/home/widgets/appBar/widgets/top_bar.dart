import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nj_pizza_delivery/app/home/cart/controller/cart_controller.dart';
import 'package:nj_pizza_delivery/routes/app_routes.dart';

class TopBarWidget extends StatelessWidget {
  final cart = Get.find<CartController>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 0),
      child: Container(
        color: Colors.deepOrange,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Builder(
                    builder:
                        (context) => GestureDetector(
                          onTap: () {
                            Scaffold.of(
                              context,
                            ).openDrawer(); // 💥 Opens Drawer
                          },
                          child: Icon(
                            Icons.menu,
                            size: 32,
                            color: Colors.white,
                          ),
                        ),
                  ),
                  SizedBox(width: 15),
                  const Text(
                    "Pizza Hub",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

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
                        return Transform.scale(
                          scale: scale,
                          child: child,
                        );
                      },
                      child: GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.CART);
                        },
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            const Icon(
                              Icons.shopping_cart,
                              size: 28,
                              color: Colors.white,
                            ),

                            /// 🔴 CART COUNT
                              Positioned(
                                top: -6,
                                right: -2,
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    count > 99 ? '99+' : '$count',
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
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
            ],
          ),
        ),
      ),
    );
  }
}
