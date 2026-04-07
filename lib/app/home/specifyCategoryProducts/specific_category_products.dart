import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nj_pizza_delivery/app/home/specifyCategoryProducts/controller/search_controller.dart';
import 'package:nj_pizza_delivery/app/home/specifyCategoryProducts/controller/specific_category_products_controller.dart';
import 'package:nj_pizza_delivery/app/home/specifyCategoryProducts/wigets/search_widgets.dart';
import '../../../constants/images_files.dart';
import '../../../routes/app_routes.dart';
import '../cart/controller/cart_controller.dart';
import '../home/model/product-model.dart';
import '../widgets/productCard/product_card.dart';

class SpecificCategoryProductsScreen
    extends GetView<SpecificCategoryProductsController> {
  SpecificCategoryProductsScreen({super.key});

  final searchController = Get.find<SpecificCategorySearchController>();
  final cart = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              _header(),
              const SizedBox(height: 12),
              SearchWidgetSpecific(),
              const SizedBox(height: 16),
              Expanded(child: _productGrid()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          InkWell(
            child: const Icon(Icons.arrow_back_ios, size: 18),
            onTap: () => Get.back(),
          ),
          const Spacer(),
          Text(
            'All ${controller.categoryName} Items',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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
        ],
      ),
    );
  }

  // ---------------- PRODUCT GRID ----------------
  Widget _productGrid() {
    return Obx(() {
      if (controller.mainPageLoading.value ||
          searchController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.products.isEmpty) {
        return const Center(
          child: Text('No items found', style: TextStyle(color: Colors.grey)),
        );
      }

      return GridView.builder(
        controller: controller.scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        itemCount:
            controller.products.length +
            (controller.moreProductLoading.value ? 1 : 0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          mainAxisExtent: 300,
        ),
        itemBuilder: (_, index) {
          if (index >= controller.products.length) {
            // bottom loader
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          }

          final product = controller.products[index];
          return productCard(product);
        },
      );
    });
  }
}
