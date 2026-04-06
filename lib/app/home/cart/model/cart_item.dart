class ExtraItem {
  final String name;
  final double price;
  final int quantity; // ✅ NEW

  const ExtraItem({
    required this.name,
    required this.price,
    this.quantity = 1, // ✅ default
  });

  factory ExtraItem.fromJson(Map<String, dynamic> json) {
    return ExtraItem(
      name: json['name'] ?? '',
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] ?? 1, // ✅ NEW
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'price': price,
    'quantity': quantity, // ✅ NEW
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ExtraItem &&
              other.name == name &&
              other.price == price &&
              other.quantity == quantity; // ✅ include

  @override
  int get hashCode =>
      name.hashCode ^ price.hashCode ^ quantity.hashCode;
}

/* =========================
   CART ITEM (FINAL)
========================= */

class MyCartModel {
  final String productId;
  final String name;
  final String image;

  /// Base product price (before discount)
  final double basePrice;

  /// Discount percentage (single, non-stackable)
  final double discountPercentage;

  /// Final price AFTER discount (per unit)
  final double finalPrice;

  /// Selected size (S / M / L)
  final String size;

  final int quantity;
  final List<ExtraItem> extras;

  const MyCartModel({
    required this.productId,
    required this.name,
    required this.image,
    required this.basePrice,
    required this.discountPercentage,
    required this.finalPrice,
    this.size = 'M',
    this.quantity = 1,
    this.extras = const [],
  });

  /* --------------------
     FACTORY
  -------------------- */

  factory MyCartModel.fromJson(Map<String, dynamic> json) {
    return MyCartModel(
      productId: json['product_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      basePrice: (json['base_price'] as num).toDouble(),
      discountPercentage:
      (json['discount_percentage'] as num?)?.toDouble() ?? 0.0,
      finalPrice: (json['final_price'] as num).toDouble(),
      size: json['size'] ?? 'M',
      quantity: json['quantity'] ?? 1,
      extras: (json['extras'] as List<dynamic>?)
          ?.map((e) => ExtraItem.fromJson(e))
          .toList() ??
          const [],
    );
  }

  /* --------------------
     SERIALIZE (API SAFE)
  -------------------- */

  Map<String, dynamic> toJson() => {
    'product_id': productId,
    'name': name,
    'image': image,
    'base_price': basePrice,
    'discount_percentage': discountPercentage,
    'final_price': finalPrice,
    'size': size,
    'quantity': quantity,
    'extras': extras.map((e) => e.toJson()).toList(),
  };

  /* --------------------
     TOTAL PRICE
  -------------------- */

  double get totalPrice {
    final extrasTotal = extras.fold(
      0.0,
          (s, e) => s + (e.price * e.quantity),
    );

    return (finalPrice * quantity) + (extrasTotal * quantity);
  }

  double get extrasTotalPerItem {
    return extras.fold(0.0, (s, e) => s + (e.price * e.quantity));
  }

  /* --------------------
     IMMUTABLE UPDATE
  -------------------- */

  MyCartModel copyWith({
    int? quantity,
    String? size,
    List<ExtraItem>? extras,
  }) {
    return MyCartModel(
      productId: productId,
      name: name,
      image: image,
      basePrice: basePrice,
      discountPercentage: discountPercentage,
      finalPrice: finalPrice,
      size: size ?? this.size,
      quantity: quantity ?? this.quantity,
      extras: extras ?? List.from(this.extras),
    );
  }

  /* --------------------
     EQUALITY
  -------------------- */

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is MyCartModel &&
              other.productId == productId &&
              other.size == size &&
              _extrasEqual(other.extras, extras);

  @override
  int get hashCode =>
      productId.hashCode ^
      size.hashCode ^
      extras.fold(0, (p, e) => p ^ e.hashCode);

  bool _extrasEqual(List<ExtraItem> a, List<ExtraItem> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
