class OrderModel {
  final String orderId;
  final double totalAmount;
  final String status;
  final String paymentStatus;
  final DateTime createdAt;

  OrderModel({
    required this.orderId,
    required this.totalAmount,
    required this.status,
    required this.paymentStatus,
    required this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['order_id'],
      totalAmount: double.parse(json['total_amount'].toString()),
      status: json['status'] ?? '',
      paymentStatus: json['payment_status'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
