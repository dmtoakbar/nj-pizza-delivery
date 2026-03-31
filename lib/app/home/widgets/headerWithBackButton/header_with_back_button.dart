import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../constants/images_files.dart';
import '../../../../routes/app_routes.dart';
import '../../cart/controller/cart_controller.dart';

class CustomHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final bool showCart;
  final bool showFavorite;
  final VoidCallback? onBackPressed;
  final VoidCallback? onCartPressed;
  final VoidCallback? onFavoritePressed;

  const CustomHeader({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.showCart = true,
    this.showFavorite = false,
    this.onBackPressed,
    this.onCartPressed,
    this.onFavoritePressed,
  });

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            if (showBackButton)
              InkWell(
                onTap: onBackPressed ?? () => Get.back(),
                child: const Icon(Icons.arrow_back_ios, size: 18),
              )
            else
              const SizedBox(width: 18),

            const SizedBox(width: 8),

            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),

            if (showCart)
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

            if (showCart && showFavorite) const SizedBox(width: 10),

            if (showFavorite)
              GestureDetector(
                onTap: onFavoritePressed,
                child: const Icon(Icons.favorite_border),
              ),

            if (showFavorite) const SizedBox(width: 18),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
