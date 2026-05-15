import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nj_pizza_delivery/app/home/home/controller/home_controller.dart';
import 'package:nj_pizza_delivery/app/home/home/controller/search_controller.dart';
import 'package:nj_pizza_delivery/app/home/home/widgets/banner_carousel.dart';
import 'package:nj_pizza_delivery/app/home/home/widgets/hero_section.dart';
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
        statusBarColor: Color(0xFFEB5525),
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFEB5525),
        drawer: SideMenuWidget(),
        bottomNavigationBar: AnimatedBottomNav(),

        /// WHOLE PAGE SCROLL
        body: SafeArea(
          child: Obx(() {
            final hasQuery = searchController.searchQuery.value.isNotEmpty;

            /// MAIN LOADING
            if (!hasQuery && controller.isMainPageLoading.value) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    /// HEADER STILL VISIBLE
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Header(home: true),
                    ),

                    const SizedBox(height: 12),

                    /// OPTIONAL HERO PLACEHOLDER
                    const PremiumHomeHero(),

                    const SizedBox(height: 16),

                    /// SEARCH PLACEHOLDER
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: IgnorePointer(
                        child: Opacity(
                          opacity: 0.6,
                          child: SearchWidget(home: true),
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    /// WHITE SECTION
                    Container(
                      height: Get.height * 0.55,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32),
                        ),
                      ),
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                  ],
                ),
              );
            }

            /// SEARCH RESULT
            /// SEARCH RESULT
            if (hasQuery) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    /// HEADER
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Header(home: true),
                    ),

                    const SizedBox(height: 12),

                    /// HERO
                    const PremiumHomeHero(),

                    const SizedBox(height: 16),

                    /// SEARCH
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SearchWidget(home: true),
                    ),

                    const SizedBox(height: 22),

                    /// WHITE CURVED SEARCH SECTION
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32),
                        ),
                      ),

                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 20,
                          left: 16,
                          right: 16,
                          bottom: 24,
                        ),
                        child: _searchResult(),
                      ),
                    ),
                  ],
                ),
              );
            }

            /// HOME PAGE
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),

                  /// HEADER
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Header(home: true),
                  ),

                  const SizedBox(height: 12),

                  /// HERO
                  const PremiumHomeHero(),

                  const SizedBox(height: 16),

                  /// SEARCH
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SearchWidget(home: true),
                  ),

                  const SizedBox(height: 22),

                  /// WHITE CONTENT SECTION
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 20,
                        left: 16,
                        right: 16,
                        bottom: 24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),

                          /// BANNERS
                          BannerCarousel(banners: controller.homeBannerList),

                          const SizedBox(height: 28),
                          premiumMenuSection(),

                          const SizedBox(height: 28),

                          premiumOfferBanner(),

                          const SizedBox(height: 28),

                          /// POPULAR MENU
                          sectionTitle(
                            'Recommended For You 🔥',
                            showSeeAll: false,
                          ),

                          const SizedBox(height: 28),

                          _popularMenu(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget premiumMenuSection() {
    final List<Color> premiumCategoryColors = [
      const Color(0xFFFFEEE8),
      const Color(0xFFFFF4E5),
      const Color(0xFFFFECEC),
      const Color(0xFFEFF7FF),
      const Color(0xFFFFF1E6),
      const Color(0xFFF4EEFF),
      const Color(0xFFEFFFF6),
      const Color(0xFFFFF8E8),
    ];

    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Our Menu",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF2B160B),
                  letterSpacing: -1,
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEEE8),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.local_fire_department,
                      size: 16,
                      color: Color(0xFFEB5525),
                    ),
                    SizedBox(width: 6),
                    Text(
                      "Trending",
                      style: TextStyle(
                        color: Color(0xFFEB5525),
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          /// CATEGORY GRID
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.categories.length,

            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 18,
              childAspectRatio: 0.74,
            ),

            itemBuilder: (_, index) {
              final category = controller.categories[index];

              final bgColor =
                  premiumCategoryColors[index % premiumCategoryColors.length];

              return GestureDetector(
                onTap: () async {
                  await Get.toNamed(
                    Routes.SPECIFICATPRODUCTS,
                    arguments: {
                      'category_id': category.id,
                      'category_name': category.name,
                    },
                  );
                },

                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),

                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(28),

                    border: Border.all(color: Colors.transparent, width: 2),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),

                        blurRadius: 10,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /// IMAGE
                      Container(
                        height: 72,
                        width: 72,
                        padding: const EdgeInsets.all(14),

                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,

                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                            ),
                          ],
                        ),

                        child:
                            category.image.isEmpty
                                ? const Icon(Icons.fastfood)
                                : CachedNetworkImage(
                                  imageUrl: category.image,
                                  fit: BoxFit.contain,
                                ),
                      ),

                      const SizedBox(height: 14),

                      /// NAME
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          category.name,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,

                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            height: 1.15,
                            color: Color(0xFF2B160B),
                            letterSpacing: -0.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      );
    });
  }

  // ---------------- SEARCH RESULT ----------------

  Widget _searchResult() {
    return Obx(() {
      if (searchController.isLoading.value) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 80),
          child: Center(child: CircularProgressIndicator()),
        );
      }

      if (searchController.allProducts.isEmpty) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 80),
          child: Center(child: Text('No products found')),
        );
      }

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: searchController.allProducts.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          mainAxisExtent: 311,
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
          padding: EdgeInsets.symmetric(vertical: 30),
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
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.allProducts.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: 0.72,
          mainAxisExtent: 311,
        ),
        itemBuilder: (_, index) {
          final product = controller.allProducts[index];

          return productCard(product);
        },
      );
    });
  }

  Widget premiumOfferBanner() {
    return Obx(() {
      if (controller.promoSliders.isEmpty) {
        return const SizedBox();
      }

      return Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(30),

            child: CarouselSlider.builder(
              itemCount: controller.promoSliders.length,

              options: CarouselOptions(
                height: 190,
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
                        padding: const EdgeInsets.all(22),

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

                            const SizedBox(height: 14),

                            /// TITLE
                            Text(
                              banner.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 26,
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

                            const SizedBox(height: 14),

                            /// BUTTON
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 5,
                              ),

                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                              ),

                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    banner.buttonText.isEmpty
                                        ? "Order Now"
                                        : banner.buttonText,
                                    style: const TextStyle(
                                      color: Color(0xFFEB5525),
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),

                                  const SizedBox(width: 6),

                                  const Icon(
                                    Icons.arrow_forward_rounded,
                                    color: Color(0xFFEB5525),
                                    size: 18,
                                  ),
                                ],
                              ),
                            ),
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
