import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nj_pizza_delivery/app/home/myFavourite/widgets/favourite_card_widget.dart';
import '../../../routes/app_routes.dart';
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
              const SizedBox(height: 4),
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
}
