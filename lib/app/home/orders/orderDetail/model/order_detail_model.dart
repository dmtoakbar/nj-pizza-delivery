class OrderItem {
  final String productId;
  final String name;
  final String image;
  final String size;

  final int quantity;

  final double basePrice;
  final double discountPercentage;
  final double finalPrice;

  final List<OrderExtra> extras;

  OrderItem({
    required this.productId,
    required this.name,
    required this.image,
    required this.size,
    required this.quantity,
    required this.basePrice,
    required this.discountPercentage,
    required this.finalPrice,
    required this.extras,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['product_id'] ?? '',
      name: json['product_name'] ?? '',
      image: json['product_image'] ?? '',
      size: json['size'] ?? 'M',
      quantity: int.tryParse(json['quantity'].toString()) ?? 1,

      basePrice:
      double.tryParse(json['base_price'].toString()) ?? 0.0,

      discountPercentage:
      double.tryParse(json['discount_percentage'].toString()) ?? 0.0,

      finalPrice:
      double.tryParse(json['final_price'].toString()) ?? 0.0,

      extras: (json['extras'] as List? ?? [])
          .map((e) => OrderExtra.fromJson(e))
          .toList(),
    );
  }


  double get extrasTotal {
    return extras.fold(0.0, (sum, e) => sum + e.price);
  }
  /// ✅ FINAL total (backend-trusted)
  double get totalPrice {
    final itemTotal = finalPrice + extrasTotal;
    return itemTotal * quantity;
  }

}

class OrderExtra {
  final String name;
  final double price;

  OrderExtra({
    required this.name,
    required this.price,
  });

  factory OrderExtra.fromJson(Map<String, dynamic> json) {
    return OrderExtra(
      name: json['extra_name'] ?? '',
      price: double.tryParse(json['extra_price'].toString()) ?? 0.0,
    );
  }
}

