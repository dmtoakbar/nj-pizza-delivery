import 'package:flutter/material.dart';
import 'controller/product_review_controller.dart';
import 'package:get/get.dart';

class ProductReviewSection extends StatelessWidget {
  final String productId;
  final bool reviewsCount;

  const ProductReviewSection({
    super.key,
    required this.productId,
    this.reviewsCount = false,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductReviewController(productId: productId));

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      /// ⭐ ONLY RATING
      if (reviewsCount) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildRatingStars(controller.avgRating.value),
                const SizedBox(width: 6),
                Text(
                  controller.avgRating.value.toStringAsFixed(1),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              "(${controller.totalReviews.value} reviews)",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ],
        );
      }

      /// 🧾 FULL REVIEWS
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Customer Reviews",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              ElevatedButton(
                onPressed: () => _openReviewSheet(controller),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEB5525),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Write Review",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// EMPTY STATE
          if (controller.reviews.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  "No reviews yet",
                  style: TextStyle(color: Colors.grey.shade500),
                ),
              ),
            ),

          /// LIST
          ...controller.reviews.map((r) {
            final userName = (r['user_name'] ?? "User").toString();
            final reviewText = (r['review'] ?? "").toString();
            final rating = int.tryParse(r['rating'].toString()) ?? 0;

            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 👤 AVATAR
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.orange.shade100,
                    child: Text(
                      userName.isNotEmpty ? userName[0].toUpperCase() : "U",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  /// CONTENT
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// NAME + STARS
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                userName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            _stars(rating),
                          ],
                        ),

                        const SizedBox(height: 6),

                        /// TEXT
                        Text(
                          reviewText,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      );
    });
  }

  /// ⭐ AVG RATING
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

  /// ⭐ USER RATING
  Widget _stars(int rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          size: 14,
          color: Colors.orange,
        );
      }),
    );
  }

  /// ✍️ SHEET
  void _openReviewSheet(ProductReviewController controller) {
    final reviewCtrl = Get.find<ProductReviewController>();

    Get.bottomSheet(
      isScrollControlled: true,
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Rate your experience",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 14),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < reviewCtrl.rating.value
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.orange,
                      size: 28,
                    ),
                    onPressed: () => reviewCtrl.setRating(index + 1),
                  );
                }),
              ),

              if (reviewCtrl.ratingError.value)
                const Text(
                  'Please select a rating',
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.left,
                ),

              const SizedBox(height: 10),

              TextField(
                maxLines: 3,
                onChanged: reviewCtrl.setReview,
                decoration: InputDecoration(
                  hintText: "Tell others about this...",
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              if (reviewCtrl.reviewError.value)
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Please write a review',
                    style: TextStyle(color: Colors.red),
                  ),
                ),

              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: () => reviewCtrl.submit(controller),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEB5525),
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Submit Review",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
