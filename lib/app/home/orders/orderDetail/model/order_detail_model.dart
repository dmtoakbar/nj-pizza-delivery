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


  double get extrasTotalPerItem {
    return extras.fold(
      0.0,
          (sum, e) => sum + (e.price * e.quantity),
    );
  }
  /// ✅ FINAL total (backend-trusted)
  double get totalPrice {
    return (finalPrice * quantity) +
        (extrasTotalPerItem * quantity);
  }

}

class OrderExtra {
  final String name;
  final double price;
  final int quantity; // ✅ ADD

  OrderExtra({
    required this.name,
    required this.price,
    required this.quantity,
  });

  factory OrderExtra.fromJson(Map<String, dynamic> json) {
    return OrderExtra(
      name: json['name'] ?? json['extra_name'] ?? '',
      price: double.tryParse(
          (json['price'] ?? json['extra_price']).toString()) ??
          0.0,
      quantity: int.tryParse(json['quantity'].toString()) ?? 1, // ✅ ADD
    );
  }
}

