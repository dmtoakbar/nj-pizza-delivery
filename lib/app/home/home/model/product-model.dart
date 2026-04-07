import '../../../../api/api_path.dart';

class ProductModel {
  final String id;
  final String categoryId;
  final String name;
  final String description;
  final double avgRating;
  final int totalReviews;

  /// All size prices (S, M, L)
  final Map<String, double> sizes;

  /// Discount percentage (0–100)
  final double discountPercentage;

  /// Default selected price (MEDIUM size after discount)
  final double finalPrice;

  /// Original medium price (before discount)
  final double basePrice;

  final String image;
  final bool isPopular;
  final bool isFeatured;

  ProductModel({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.sizes,
    required this.discountPercentage,
    required this.basePrice,
    required this.finalPrice,
    required this.image,
    required this.isPopular,
    required this.isFeatured,
    required this.avgRating,
    required this.totalReviews,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    /// Parse sizes safely
    final Map<String, double> sizes = (json['sizes'] as Map<String, dynamic>)
        .map((key, value) => MapEntry(key, (value as num).toDouble()));

    /// Default size = Medium
    final double mediumPrice = sizes['M'] ?? 0.0;

    final double discountPercentage =
        (json['discount_percentage'] as num?)?.toDouble() ?? 0.0;

    /// Apply percentage discount
    final double finalPrice =
        discountPercentage > 0
            ? mediumPrice - (mediumPrice * discountPercentage / 100)
            : mediumPrice;

    return ProductModel(
      id: json['id'],
      categoryId: json['category_id'],
      name: json['name'],
      description: json['description'] ?? '',
      sizes: sizes,
      discountPercentage: discountPercentage,
      basePrice: mediumPrice,
      finalPrice: double.parse(finalPrice.toStringAsFixed(2)),
      image:
          json['image'] != null && json['image'].toString().isNotEmpty
              ? "${ApiPath.medianPath}${json['image']}"
              : '',
      isPopular: json['is_popular'] == true || json['is_popular'] == 1,
      isFeatured: json['is_featured'] == true || json['is_featured'] == 1,

      avgRating: _toDouble(json['avg_rating']),
      totalReviews: _toInt(json['total_reviews']),
    );
  }
}

double _toDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0.0;
}

int _toInt(dynamic value) {
  if (value == null) return 0;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString()) ?? 0;
}
