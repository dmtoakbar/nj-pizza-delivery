class AddressModel {
  final String label;
  final String name;
  final String phone;
  final String address;

  AddressModel({
    required this.label,
    required this.name,
    required this.phone,
    required this.address,
  });

  Map<String, dynamic> toJson() => {
    'label': label,
    'name': name,
    'phone': phone,
    'address': address,
  };

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
    label: json['label'] ?? 'Home',
    name: json['name'] ?? '',
    phone: json['phone'] ?? '',
    address: json['address'] ?? '',
  );
}
