import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nj_pizza_delivery/app/home/home/controller/home_controller.dart';
import 'package:nj_pizza_delivery/app/home/home/controller/search_controller.dart';
import 'package:nj_pizza_delivery/app/home/home/widgets/banner_card.dart';
import 'package:nj_pizza_delivery/app/home/home/widgets/search_widget.dart';
import 'package:nj_pizza_delivery/app/home/home/widgets/section_title.dart';
import 'package:nj_pizza_delivery/app/home/widgets/appBar/header.dart';
import 'package:nj_pizza_delivery/app/home/widgets/bottomAppBar/animated_bottom_nav.dart';
import 'package:nj_pizza_delivery/routes/app_routes.dart';

import '../widgets/appBar/widgets/side_bar.dart';
import '../widgets/productCard/product_card.dart';

class HomeScreen extends GetView<HomeController> {
  HomeScreen({super.key});

  late final SearchHomeController searchController =
      Get.find<SearchHomeController>();

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
        bottomNavigationBar: AnimatedBottomNav(),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Header(),
                const SizedBox(height: 4),
                Obx(() {
                  final isLoading = controller.isMainPageLoading.value;
                  final hasQuery =
                      searchController.searchQuery.value.isNotEmpty;

                  if (isLoading && !hasQuery) {
                    return const SizedBox(); // ❌ hide search during loading
                  }

                  return Column(
                    children: [
                      const SizedBox(height: 16),
                      SearchWidget(),
                      const SizedBox(height: 24),
                    ],
                  );
                }),

                Obx(() {
                  final hasQuery =
                      searchController.searchQuery.value.isNotEmpty;
                  if (!hasQuery && controller.isMainPageLoading.value) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: Get.height * 0.35),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (hasQuery) {
                    return Expanded(child: _searchResult());
                  }

                  return Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          sectionTitle('Extra Discount', showSeeAll: false),
                          const SizedBox(height: 12),
                          _homeBanners(),
                          const SizedBox(height: 24),
                          sectionTitle(
                            'Categories',
                            onSeeAll: () async {
                              await Get.toNamed(Routes.ALLCATPRODUCTS);
                            },
                          ),
                          const SizedBox(height: 12),
                          _categories(),
                          const SizedBox(height: 24),
                          sectionTitle(
                            'Popular Menu',
                            onSeeAll: () async {
                              final selectedCat = controller.categories
                                  .firstWhere(
                                    (c) =>
                                        c.id ==
                                        controller.selectedCategory.value,
                                  );
                              await Get.toNamed(
                                Routes.SPECIFICATPRODUCTS,
                                arguments: {
                                  'category_id': selectedCat.id,
                                  'category_name': selectedCat.name,
                                },
                              );
                            },
                          ),

                          const SizedBox(height: 12),
                          _popularMenu(),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _homeBanners() {
    return Obx(() {
      if (controller.homeBannerList.isEmpty) {
        return const SizedBox();
      }

      return SizedBox(
        height: 150,
        child: PageView.builder(
          itemCount: controller.homeBannerList.length,
          controller: PageController(viewportFraction: 1),
          itemBuilder: (_, index) {
            final banner = controller.homeBannerList[index];
            return bannerCard(banner);
          },
        ),
      );
    });
  }

  // ---------------- CATEGORIES ----------------
  Widget _categories() {
    return Obx(() {
      return Align(
        alignment: Alignment.centerLeft,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(controller.categories.length, (index) {
              final category = controller.categories[index];

              final selected = controller.selectedCategory.value == category.id;

              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () => controller.selectCategory(category.id),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color:
                            selected
                                ? const Color(0xFFEB5525)
                                : Colors.grey.shade300,
                      ),
                    ),
                    child: Row(
                      children: [
                        CachedNetworkImage(
                          imageUrl: category.image,
                          height: 16,
                          color:
                              selected ? const Color(0xFFEB5525) : Colors.grey,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          category.name,
                          style: TextStyle(
                            color:
                                selected
                                    ? const Color(0xFFEB5525)
                                    : Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      );
    });
  }

  // search result

  Widget _searchResult() {
    return Obx(() {
      if (searchController.isLoading.value) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 100),
          child: Center(child: CircularProgressIndicator()),
        );
      }

      if (searchController.allProducts.isEmpty) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 100),
          child: Center(child: Text('No products found')),
        );
      }

      return GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        itemCount: searchController.allProducts.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          mainAxisExtent: 300,
        ),
        itemBuilder: (_, index) {
          final product = searchController.allProducts[index];
          return productCard(product);
        },
      );
    });
  }

  // ---------------- POPULAR MENU ----------------
  Widget _popularMenu() {
    return Obx(() {
      if (controller.categoryFilterProductLoading.value) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Center(child: CircularProgressIndicator()),
        );
      }

      if (controller.allProducts.isEmpty) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Center(child: Text('No products found')),
        );
      }

      return GridView.builder(
        shrinkWrap: true, // ✅ VERY IMPORTANT
        physics: const NeverScrollableScrollPhysics(), // ✅ disable inner scroll
        itemCount: controller.allProducts.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: 0.72,
          mainAxisExtent: 300,
        ),
        itemBuilder: (_, index) {
          final product = controller.allProducts[index];
          return productCard(product);
        },
      );
    });
  }
}
