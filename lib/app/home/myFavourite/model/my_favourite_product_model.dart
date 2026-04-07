
import '../../home/model/product-model.dart';

class MyFavouriteProductModel {
  final String id;
  final String categoryId;
  final String name;
  final String description;
  final double avgRating;
  final int totalReviews;

  /// Stored sizes snapshot (S, M, L)
  final Map<String, double> sizes;

  /// Stored discount snapshot
  final double discountPercentage;

  /// Medium price before discount
  final double basePrice;

  /// Medium price after discount
  final double finalPrice;

  final String image;
  final bool isPopular;
  final bool isFeatured;

  MyFavouriteProductModel({
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

  factory MyFavouriteProductModel.fromJson(Map<String, dynamic> json) {
    final Map<String, double> sizes =
    (json['sizes'] as Map<String, dynamic>).map(
          (key, value) => MapEntry(key, (value as num).toDouble()),
    );

    final double discountPercentage =
        (json['discount_percentage'] as num?)?.toDouble() ?? 0.0;

    final double mediumPrice = sizes['M'] ?? 0.0;

    final double finalPrice = discountPercentage > 0
        ? mediumPrice - (mediumPrice * discountPercentage / 100)
        : mediumPrice;

    return MyFavouriteProductModel(
      id: json['id'],
      categoryId: json['category_id'],
      name: json['name'],
      description: json['description'] ?? '',
      sizes: sizes,
      discountPercentage: discountPercentage,
      basePrice: mediumPrice,
      finalPrice: double.parse(finalPrice.toStringAsFixed(2)),
      image: json['image'] ?? '',
      isPopular: json['is_popular'] == true || json['is_popular'] == 1,
      isFeatured: json['is_featured'] == true || json['is_featured'] == 1,
      avgRating: _toDouble(json['avg_rating']),
      totalReviews: _toInt(json['total_reviews']),
    );
  }
}


extension ProductModelExtension on ProductModel {
  MyFavouriteProductModel toFavorite() {
    return MyFavouriteProductModel(
      id: id,
      categoryId: categoryId,
      name: name,
      description: description,
      sizes: sizes,
      discountPercentage: discountPercentage,
      basePrice: basePrice,
      finalPrice: finalPrice,
      image: image,
      isPopular: isPopular,
      isFeatured: isFeatured,
      avgRating: avgRating,
      totalReviews: totalReviews
    );
  }
}


extension MyFavouriteProductModelExtension on MyFavouriteProductModel {
  ProductModel toProductModel() {
    return ProductModel(
      id: id,
      categoryId: categoryId,
      name: name,
      description: description,
      sizes: sizes,
      discountPercentage: discountPercentage,
      basePrice: basePrice,
      finalPrice: finalPrice,
      image: image,
      isPopular: isPopular,
      isFeatured: isFeatured,
      avgRating: avgRating,
      totalReviews: totalReviews,
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

