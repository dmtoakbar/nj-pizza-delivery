import '../../../../api/api_path.dart';

class CategoriesModel {
  final String id;
  final String name;
  final String image;
  final int showSize;
  final int showTopping;

  CategoriesModel({
    required this.id,
    required this.name,
    required this.image,
    required this.showSize,
    required this.showTopping,
  });

  factory CategoriesModel.fromJson(Map<String, dynamic> json) {
    return CategoriesModel(
      id: json['id'],
      name: json['name'],
      showSize: json['show_sizes'],
      showTopping: json['show_toppings'],
      image:
          json['image'] != null && json['image'].toString().isNotEmpty
              ? "${ApiPath.medianPath}${json['image']}"
              : '',
    );
  }

  factory CategoriesModel.all() {
    return CategoriesModel(
      id: 'all',

      name: 'All',

      image: '',

      showSize: 1,

      showTopping: 1,
    );
  }
}
