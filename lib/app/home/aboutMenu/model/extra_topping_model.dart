import '../../../../../api/api_path.dart';
class ToppingExtra {
  final String id;
  final String name;
  final String image;
  final double price;

  const ToppingExtra({
    required this.name,
    required this.image,
    required this.price,
    required this.id,
  });

  factory ToppingExtra.fromJson(Map<String, dynamic> json) {
    return ToppingExtra(
      id: json['id'],
      name: json['name'],
      image:
      json['image'] != null && json['image'].toString().isNotEmpty
          ? "${ApiPath.medianPath}${json['image']}"
          : '',
      price: (json['price'] as num).toDouble(),
    );
  }
}