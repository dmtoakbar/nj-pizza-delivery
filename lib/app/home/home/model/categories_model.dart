import '../../../../api/api_path.dart';

class CategoriesModel {
  final String id;
  final String name;
  final String image;


  CategoriesModel({
    required this.id,
    required this.name,
    required this.image,
  });

  factory CategoriesModel.fromJson(Map<String, dynamic> json) {
    return CategoriesModel(
      id: json['id'],
      name: json['name'],
      image: json['image'] != null && json['image'].toString().isNotEmpty
          ? "${ApiPath.medianPath}${json['image']}"
          : '',
    );
  }

  factory CategoriesModel.all() {
    return CategoriesModel(
      id: 'all',
      name: 'All',
      image: '',
    );
  }
}
