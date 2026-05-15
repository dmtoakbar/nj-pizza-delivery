import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nj_pizza_delivery/app/home/orders/controller/orders_controller.dart';
import 'package:nj_pizza_delivery/app/home/orders/widgets/order_card_widget.dart';
import '../../../routes/app_routes.dart';
import '../widgets/appBar/header.dart';
import '../widgets/appBar/widgets/side_bar.dart';
import '../widgets/bottomAppBar/animated_bottom_nav.dart';

class OrdersView extends GetView<OrderController> {
  OrdersView({super.key});

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
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: premiumOfferBanner(),
              ),
              const SizedBox(height: 4),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.orange),
                    );
                  }

                  if (controller.orders.isEmpty) {
                    return const Center(
                      child: Text(
                        "No orders found",
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: controller.orders.length,
                    itemBuilder: (context, index) {
                      final order = controller.orders[index];

                      return OrderCard(
                        orderId: order.orderId,
                        createdAt: order.createdAt,
                        totalAmount: order.totalAmount,
                        status: order.status,
                        paymentStatus: order.paymentStatus,
                        onTap: () {
                          Get.toNamed(
                            Routes.ORDERDETAIL,
                            arguments: {'order_id': order.orderId},
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
