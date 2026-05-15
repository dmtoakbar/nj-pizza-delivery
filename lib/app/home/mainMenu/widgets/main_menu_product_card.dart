import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nj_pizza_delivery/app/home/myFavourite/controller/my_favourite_controller.dart';

import '../../../../routes/app_routes.dart';
import '../../home/model/product-model.dart';
import '../../myFavourite/model/my_favourite_product_model.dart';

Widget mainMenuProductCard(ProductModel product) {
  final favController = Get.find<FavoritesController>();

  return GestureDetector(
    onTap: () {
      Get.toNamed(Routes.ABOUTMENU, arguments: product);
    },

    child: Container(
      padding: const EdgeInsets.all(8),

      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFE1C7), Colors.white],
        ),

        borderRadius: BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ================= TOP SECTION =================
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// IMAGE
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),

                      child: SizedBox(
                        width: 110,
                        height: double.infinity,

                        child: CachedNetworkImage(
                          imageUrl: product.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    /// DISCOUNT
                    Positioned(
                      top: 8,
                      left: 0,

                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),

                        decoration: BoxDecoration(
                          color: const Color(0xFFEB5525),
                          borderRadius: BorderRadius.circular(6),
                        ),

                        child: Text(
                          '${product.discountPercentage}% OFF',

                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),

                    /// FAVORITE
                    Positioned(
                      top: 8,
                      right: 8,

                      child: Obx(() {
                        final isFav = favController.isFavorite(product.id);

                        return GestureDetector(
                          onTap: () {
                            favController.toggleFavorite(product.toFavorite());
                          },

                          child: Container(
                            padding: const EdgeInsets.all(5),

                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),

                            child: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,

                              color:
                                  isFav ? const Color(0xFFEB5525) : Colors.red,

                              size: 16,
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),

                const SizedBox(width: 4),

                /// DETAILS
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      /// TITLE
                      Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,

                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),

                      const SizedBox(height: 4),

                      /// DESCRIPTION
                      Expanded(
                        child: Text(
                          product.description ?? '',

                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,

                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            height: 1.4,
                          ),
                        ),
                      ),
                      SizedBox(height: 4),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Row(
            children: [
              _buildRatingStars(product.avgRating),

              const SizedBox(width: 5),

              Text(
                product.avgRating.toStringAsFixed(1),

                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),

          /// ================= BOTTOM SECTION =================
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// PRICE
              Expanded(
                child: Row(
                  children: [
                    Text(
                      '\$${product.basePrice}',

                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),

                    const SizedBox(width: 6),

                    Text(
                      '\$${product.finalPrice}',

                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              /// BUTTON
              SizedBox(
                width: 100,
                height: 38,

                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed(Routes.ABOUTMENU, arguments: product);
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEB5525),

                    elevation: 0,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  child: const Text(
                    'View',

                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _buildRatingStars(double rating) {
  return Row(
    children: List.generate(5, (index) {
      if (index < rating.floor()) {
        return const Icon(Icons.star, color: Colors.orange, size: 14);
      } else if (index < rating) {
        return const Icon(Icons.star_half, color: Colors.orange, size: 14);
      } else {
        return const Icon(Icons.star_border, color: Colors.orange, size: 14);
      }
    }),
  );
}
