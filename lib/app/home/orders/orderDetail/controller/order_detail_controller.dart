import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../api/api_path.dart';
import '../../../../../api/config.dart';
import '../model/order_detail_model.dart';

class OrderDetailsController extends GetxController {
  final RxBool loading = true.obs;

  final RxList<OrderItem> items = <OrderItem>[].obs;
  final RxMap<String, dynamic> orderData = <String, dynamic>{}.obs;

  late final String orderId;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments as Map<String, dynamic>;
    orderId = args['order_id'].toString();

    fetchOrderDetails();
  }

  double get totalAmount =>
      double.tryParse(orderData['total_amount']?.toString() ?? '0') ?? 0.0;

  Future<void> fetchOrderDetails() async {
    try {
      loading.value = true;

      final response = await Config.dio.get(
        '/${ApiPath.orderDetail}',
        queryParameters: {'order_id': orderId},
      );

      if (response.data == null || response.data['success'] != true) {
        return;
      }

      final data = response.data['data'];
      if (data == null) return;

      /* ---------------- ORDER ---------------- */
      orderData.assignAll(data['order'] ?? {});

      /* ---------------- ITEMS ---------------- */
      final List list = data['items'] ?? [];

      items.assignAll(
        list.map((e) => OrderItem.fromJson(e)).toList(),
      );

      debugPrint('Order loaded: $orderId');
      debugPrint('Items count: ${items.length}');
    } catch (e) {
      debugPrint('Order detail error: $e');
    } finally {
      loading.value = false;
    }
  }
}
