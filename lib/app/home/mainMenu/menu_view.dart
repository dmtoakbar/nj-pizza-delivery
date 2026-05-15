import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nj_pizza_delivery/app/home/mainMenu/widgets/main_menu_product_card.dart';
import 'package:nj_pizza_delivery/app/home/mainMenu/widgets/main_menu_search_widget.dart';
import 'package:nj_pizza_delivery/app/home/widgets/appBar/header.dart';
import '../cart/controller/cart_controller.dart';
import '../widgets/appBar/widgets/side_bar.dart';
import '../widgets/bottomAppBar/animated_bottom_nav.dart';
import 'controller/menu_controller.dart';
import 'controller/menu_search_controller.dart';

class MainMenuView extends GetView<MainMenuController> {
  MainMenuView({super.key});

  final searchController = Get.find<MenuSearchController>();
  final cart = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xFFF5F1EA),
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Color(0xFFF5F1EA),
        drawer: SideMenuWidget(),
        bottomNavigationBar: AnimatedBottomNav(),

        /// KEEPING HEADER + BOTTOM NAV UNTOUCHED
        body: SafeArea(
          child: Column(
            children: [
              /// HEADER
              Container(
                color: Color(0xFFF5F1EA),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Header(),
                ),
              ),

              /// BODY
              Expanded(
                child: Obx(() {
                  if (controller.initialDataLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Container(
                    decoration: const BoxDecoration(color: Color(0xFFF5F1EA)),
                    child: Column(
                      children: [
                        SizedBox(height: 16),
                        MainMenuSearchWidget(),
                        SizedBox(height: 16),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// LEFT CATEGORY SIDEBAR
                              _categorySidebar(),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 16),
                                  child: _productGrid(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= LEFT CATEGORY PANEL =================

  Widget _categorySidebar() {
    return Obx(() {
      if (controller.categories.isEmpty) {
        return const SizedBox(
          width: 112,
          child: Center(child: CircularProgressIndicator()),
        );
      }

      return Container(
        width: 112,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFEDE3D4),
          borderRadius: BorderRadius.circular(22),
        ),
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
          itemCount: controller.categories.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, index) {
            return Obx(() {
              final item = controller.categories[index];

              final selected =
                  controller.selectedCategory.value.toString() ==
                  item.id.toString();

              return GestureDetector(
                onTap: () {
                  controller.changeCategory(id: item.id);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: selected ? const Color(0xFF5A1F0E) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color:
                          selected
                              ? const Color(0xFF5A1F0E)
                              : Colors.brown.withOpacity(0.08),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 48,
                        width: 48,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Image.network(
                          item.image,
                          errorBuilder: (_, __, ___) => const Icon(Icons.image),
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        item.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color:
                              selected ? Colors.white : const Color(0xFF4E342E),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            });
          },
        ),
      );
    });
  }

  // ================= PRODUCT GRID =================

  Widget _productGrid() {
    return Obx(() {
      if (controller.mainPageLoading.value ||
          searchController.isLoading.value) {
        return SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: const Center(child: CircularProgressIndicator()),
        );
      }

      if (controller.products.isEmpty) {
        return SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: const Center(
            child: Text('No items found', style: TextStyle(color: Colors.grey)),
          ),
        );
      }

      return GridView.builder(
        controller: controller.scrollController,
        padding: const EdgeInsets.only(bottom: 20),
        itemCount:
            controller.products.length +
            (controller.moreProductLoading.value ? 1 : 0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          mainAxisSpacing: 14,
          childAspectRatio: 1.45,
        ),
        itemBuilder: (_, index) {
          if (index >= controller.products.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          }

          final product = controller.products[index];

          return mainMenuProductCard(product);
        },
      );
    });
  }
}
