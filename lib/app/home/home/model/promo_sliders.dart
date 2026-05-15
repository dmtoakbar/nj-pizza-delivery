import '../../../../api/api_path.dart';

class PromoSliderModel {
  final String id;
  final String title;
  final String subtitle;
  final String image;
  final String buttonText;

  PromoSliderModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.buttonText,
  });

  factory PromoSliderModel.fromJson(Map<String, dynamic> json) {
    return PromoSliderModel(
      id: json['id'] ?? '',

      title: json['title'] ?? '',

      subtitle: json['subtitle'] ?? '',

      image:
      json['image'] != null &&
          json['image'].toString().isNotEmpty
          ? "${ApiPath.medianPath}${json['image']}"
          : '',

      buttonText: json['button_text'] ?? '',
    );
  }
}