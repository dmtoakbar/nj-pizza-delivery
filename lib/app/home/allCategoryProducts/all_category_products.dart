import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nj_pizza_delivery/app/home/allCategoryProducts/controller/search_controller.dart';
import 'package:nj_pizza_delivery/app/home/allCategoryProducts/widgets/search_widgets.dart';
import '../../../constants/images_files.dart';
import '../../../routes/app_routes.dart';
import '../cart/controller/cart_controller.dart';
import '../home/model/categories_model.dart';
import '../home/model/product-model.dart';
import '../widgets/productCard/product_card.dart';
import 'controller/all_category_products_controller.dart';

class AllCategoryProductsScreen extends GetView<AllCategoryProductsController> {
  AllCategoryProductsScreen({super.key});

  final searchController = Get.find<AllCategorySearchController>();
  final cart = Get.find<CartController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _header(),
            const SizedBox(height: 12),
            AllCategorySearchWidget(),
            const SizedBox(height: 12),
            Obx(() {
              final hasQuery = searchController.searchQuery.value.isNotEmpty;

              if (hasQuery) {
                return Expanded(child: _searchProduct());
              }

              return Expanded(child: _categoryList());
            }),
          ],
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
            onTap: Get.back,
            child: const Icon(Icons.arrow_back_ios, size: 18),
          ),
          const Spacer(),
          const Text(
            'All Categories',
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

  Widget _categoryList() {
    return Obx(() {
      if (controller.loading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.categories.isEmpty) {
        return const Center(child: Text('No categories found'));
      }

      return ListView.builder(
        padding: const EdgeInsets.only(bottom: 16),
        itemCount: controller.categories.length,
        itemBuilder: (_, index) {
          final category = controller.categories[index];
          return _categorySection(category, controller);
        },
      );
    });
  }

  Widget _categorySection(
    CategoriesModel category,
    AllCategoryProductsController controller,
  ) {
    final products = controller.categoryProducts[category.id] ?? [];

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFEB5525), // light section background
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Text(
                    category.name,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  if (controller.hasMore(category.id))
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        Get.toNamed(
                          Routes.SPECIFICATPRODUCTS,
                          arguments: {
                            'categoryId': category.id,
                            'categoryName': category.name,
                          },
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        child: Row(
                          children: const [
                            Text(
                              'View all',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 12,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          /// Grid
          GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              mainAxisExtent: 311,
            ),
            itemBuilder: (_, i) => productCard(products[i]),
          ),
        ],
      ),
    );
  }

  // search product or list
  Widget _searchProduct() {
    return Obx(() {
      if (searchController.isLoading.value) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
    
      if (searchController.searchProducts.isEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsetsGeometry.only(top: Get.height * .3),
            child: Text('No products found'),
          ),
        );
      }
      return GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        shrinkWrap: true,
        itemCount: searchController.searchProducts.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          mainAxisExtent: 311,
        ),
        itemBuilder:
            (_, i) => productCard(searchController.searchProducts[i]),
      );
    });
  }
}
