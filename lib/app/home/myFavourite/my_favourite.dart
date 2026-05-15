import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nj_pizza_delivery/app/home/myFavourite/widgets/favourite_card_widget.dart';
import '../../../routes/app_routes.dart';
import '../aboutMenu/controller/pizza_topping_controller.dart';
import '../widgets/appBar/header.dart';
import '../widgets/appBar/widgets/side_bar.dart';
import '../widgets/bottomAppBar/animated_bottom_nav.dart';
import 'controller/my_favourite_controller.dart';
import 'model/my_favourite_product_model.dart';

class FavoritesScreen extends StatelessWidget {
  FavoritesScreen({super.key});

  final controller = Get.find<FavoritesController>();
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
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
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: premiumOfferBanner(),
              ),
              SizedBox(height: 4),
              Expanded(
                child: Obx(() {
                  if (controller.favorites.isEmpty) {
                    return const Center(
                      child: Text(
                        "No favorites yet",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: controller.favorites.length,
                    itemBuilder: (context, index) {
                      final product = controller.favorites[index];
                      return FavoriteCard(
                        product: product,
                        onRemove: () => controller.removeFavorite(product.id),
                        onTap: () {
                          if (Get.isRegistered<PizzaToppingController>()) {
                            Get.delete<PizzaToppingController>();
                          }
                          final productModel = product.toProductModel();
                          Get.toNamed(
                            Routes.ABOUTMENU,
                            arguments: productModel,
                          );
                        },
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const AnimatedBottomNav(),
      ),
    );
  }

  Widget premiumOfferBanner() {
    return Obx(() {
      if (controller.promoSliders.isEmpty) {
        return const SizedBox();
      }

      return Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),

            child: CarouselSlider.builder(
              itemCount: controller.promoSliders.length,

              options: CarouselOptions(
                height: 120,
                viewportFraction: 1,
                autoPlay: true,
                enlargeCenterPage: false,
                autoPlayInterval: const Duration(seconds: 4),
              ),

              itemBuilder: (_, index, __) {
                final banner = controller.promoSliders[index];

                return GestureDetector(
                  onTap: () {
                    /// OPEN PAGE / PRODUCT / CATEGORY
                  },

                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      /// IMAGE
                      CachedNetworkImage(
                        imageUrl: banner.image,
                        fit: BoxFit.cover,
                      ),

                      /// DARK OVERLAY
                      Container(color: Colors.black.withOpacity(0.42)),

                      /// ORANGE GRADIENT
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFFEB5525).withOpacity(0.82),
                              Colors.black.withOpacity(0.38),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                      ),

                      /// PREMIUM CIRCLES
                      Positioned(
                        top: -30,
                        right: -20,
                        child: Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.08),
                          ),
                        ),
                      ),

                      Positioned(
                        bottom: -40,
                        left: -20,
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.06),
                          ),
                        ),
                      ),

                      /// CONTENT
                      Padding(
                        padding: const EdgeInsets.all(12),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            /// BADGE
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),

                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.16),
                                borderRadius: BorderRadius.circular(30),
                              ),

                              child: const Text(
                                "SPECIAL OFFER",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),

                            const SizedBox(height: 8),

                            /// TITLE
                            Text(
                              banner.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                height: 1.1,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -1,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),

                            if (banner.subtitle.isNotEmpty) ...[
                              const SizedBox(height: 10),

                              Text(
                                banner.subtitle,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.92),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }
}
