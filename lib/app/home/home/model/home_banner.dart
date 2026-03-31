import '../../../../api/api_path.dart';

class HomeBannerModel {
  final String id;
  final String title;
  final String? subtitle;
  final String image;
  final String? discountText;
  final DateTime? validTill;
  final bool status;
  final int sortOrder;
  final DateTime createdAt;

  HomeBannerModel({
    required this.id,
    required this.title,
    this.subtitle,
    required this.image,
    this.discountText,
    this.validTill,
    required this.status,
    required this.sortOrder,
    required this.createdAt,
  });

  /// FROM JSON
  factory HomeBannerModel.fromJson(Map<String, dynamic> json) {
    return HomeBannerModel(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      image:
          json['image'] != null && json['image'].toString().isNotEmpty
              ? "${ApiPath.medianPath}${json['image']}"
              : '',
      discountText: json['discount_text'],
      validTill:
          json['valid_till'] != null
              ? DateTime.parse(json['valid_till'])
              : null,
      status: json['status'] == 1 || json['status'] == true,
      sortOrder: int.tryParse(json['sort_order'].toString()) ?? 0,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'image': image,
      'discount_text': discountText,
      'valid_till': validTill?.toIso8601String().split('T').first,
      'status': status ? 1 : 0,
      'sort_order': sortOrder,
    };
  }
}
