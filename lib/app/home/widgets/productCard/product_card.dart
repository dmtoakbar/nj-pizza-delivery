import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nj_pizza_delivery/app/home/myFavourite/controller/my_favourite_controller.dart';
import '../../../../routes/app_routes.dart';
import '../../home/model/product-model.dart';
import '../../myFavourite/model/my_favourite_product_model.dart';

Widget productCard(ProductModel product) {
  final favController = Get.find<FavoritesController>();
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        /// IMAGE (takes top space naturally)
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: Stack(
            children: [
              /// IMAGE
              AspectRatio(
                aspectRatio: 1.2,
                child: CachedNetworkImage(
                  imageUrl: product.image,
                  fit: BoxFit.cover,
                ),
              ),

              /// DISCOUNT BADGE (Top Left)
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEB5525),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${product.discountPercentage}% OFF',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              /// HEART ICON (Top Right)
              Positioned(
                top: 10,
                right: 10,
                child: Obx(() {
                  final isFav = favController.isFavorite(product.id);

                  return GestureDetector(
                    onTap:
                        () =>
                        favController.toggleFavorite(product.toFavorite()),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        size: 18,
                        color: isFav ? const Color(0xFFEB5525) : Colors.red,
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
        Spacer(),

        /// CONTENT
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 4),
              Text(
                product.description ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 6),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '\$${product.basePrice}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  SizedBox(width: 6),
                  Text(
                    '\$${product.finalPrice}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              SizedBox(height: 6),
              SizedBox(
                width: double.infinity,
                height: 35,
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.ABOUTMENU, arguments: product);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEB5525),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'View',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
