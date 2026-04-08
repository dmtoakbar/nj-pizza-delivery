import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/my_favourite_product_model.dart';

class FavoriteCard extends StatelessWidget {
  final MyFavouriteProductModel product;
  final VoidCallback onRemove;
  final VoidCallback? onTap;

  const FavoriteCard({
    super.key,
    required this.product,
    required this.onRemove,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: [0.0, 0.8],
            colors: [
              Color(0xFFFFE1C7), // 👈 EXACT peach
              Colors.white,
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// PRODUCT IMAGE
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Stack(
                  children: [
                    Image.network(
                      product.image,
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                    ),

                    /// DISCOUNT BADGE
                    Positioned(
                      top: 6,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEB5525),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "${product.discountPercentage}% OFF",
                          style: GoogleFonts.poppins(
                            fontSize: 9,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 14),

              /// DETAILS
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// NAME
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    Row(
                      children: [
                        _buildRatingStars(product.avgRating),
                        const SizedBox(width: 6),
                        Text(
                          product.avgRating.toStringAsFixed(1),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    /// DESCRIPTION
                    Text(
                      product.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 6),

                    /// PRICE ROW
                    Row(
                      children: [
                        Text(
                          "\$${product.basePrice.toStringAsFixed(2)}",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "\$${product.finalPrice.toStringAsFixed(2)}",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: const Color(0xFFEB5525),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              /// REMOVE BUTTON
              SizedBox(
                height: 90,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: onRemove,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.08),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                    ),

                    const Spacer(),

                    SizedBox(
                      height: 30,
                      child: ElevatedButton(
                        onPressed: onTap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEB5525),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          "View",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


Widget _buildRatingStars(double rating) {
  return Row(
    children: List.generate(5, (index) {
      if (index < rating.floor()) {
        return const Icon(Icons.star, color: Colors.orange, size: 16);
      } else if (index < rating) {
        return const Icon(Icons.star_half, color: Colors.orange, size: 16);
      } else {
        return const Icon(Icons.star_border, color: Colors.orange, size: 16);
      }
    }),
  );
}
