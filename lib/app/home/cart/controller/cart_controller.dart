import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' hide FormData;
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:nj_pizza_delivery/api/api_path.dart';
import 'package:nj_pizza_delivery/api/config.dart';
import 'package:nj_pizza_delivery/routes/app_routes.dart';
import 'package:nj_pizza_delivery/utils/app_toast.dart';
import '../model/cart_item.dart';

class CartController extends GetxController {
  final RxList<MyCartModel> items = <MyCartModel>[].obs;

  final RxBool checkOuting = false.obs;
  final RxBool placingOrder = false.obs;

  static const _cartKey = 'cart_items';

  /* -------------------- TOAST -------------------- */

  void _showToast(String msg, {bool success = true}) {
    Fluttertoast.showToast(
      msg: msg,
      backgroundColor: success ? Colors.green : Colors.red,
      textColor: Colors.white,
    );
  }

  /* -------------------- STORAGE -------------------- */

  Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode(items.map((e) => e.toJson()).toList());
    await prefs.setString(_cartKey, data);
  }

  Future<void> _loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_cartKey);

    if (data != null && data.isNotEmpty) {
      final decoded = jsonDecode(data) as List;
      items.assignAll(decoded.map((e) => MyCartModel.fromJson(e)).toList());
    }
  }

  @override
  void onInit() {
    super.onInit();
    _loadCart();
  }

  /* -------------------- CART LOGIC -------------------- */

  /// Merge: same product + same size + same extras
  void addItem(MyCartModel item) {
    final index = items.indexWhere((existing) => existing == item);

    if (index != -1) {
      final old = items[index];
      items[index] = old.copyWith(quantity: old.quantity + item.quantity);
      _showToast('Item quantity updated');
    } else {
      items.add(item);
      _showToast('Item added to cart');
    }
    _saveCart();
  }

  void removeItem(int index) {
    items.removeAt(index);
    _saveCart();
    _showToast('Item removed');
  }

  void increaseQty(int index) {
    final item = items[index];
    items[index] = item.copyWith(quantity: item.quantity + 1);
    _saveCart();
  }

  void decreaseQty(int index) {
    final item = items[index];
    if (item.quantity > 1) {
      items[index] = item.copyWith(quantity: item.quantity - 1);
      _saveCart();
    }
  }

  void clearCart() {
    items.clear();
    _saveCart();
  }

  /* -------------------- PRICE -------------------- */

  double get subtotal => items.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get tax => subtotal * 0.18;

 // double get total => subtotal + tax;

  double get total => subtotal;

  /// ✅ Returns final payable amount (subtotal + tax)
  double getTotalPrice() {
    final subtotal = items.fold(0.0, (sum, item) => sum + item.totalPrice);

    // final tax = subtotal * 0.18;
    //
    // return subtotal + tax;

    return subtotal;
  }

  /* -------------------- CHECKOUT -------------------- */

  Future<void> checkOut() async {
    if (items.isEmpty) {
      AppToast.error("Please add items to cart");
      return;
    }
    Get.toNamed(Routes.PLACEORDER);
  }

  Future<void> placeOrder({
    required String name,
    required String phone,
    required String address,
  }) async {
    if (items.isEmpty) {
      AppToast.error("Cart is empty");
      return;
    }

    try {
      placingOrder.value = true;

      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');

      if (userId == null || userId.isEmpty) {
        AppToast.error("User not logged in");
        return;
      }

      final cartPayload =
          items.map((item) {
            return {
              "product_id": item.productId,
              "name": item.name,
              "image": item.image,
              "size": item.size,
              "quantity": item.quantity,
              "base_price": item.basePrice,
              "discount_percentage": item.discountPercentage,
              "final_price": item.finalPrice,
              "extras": item.extras.map((e) => e.toJson()).toList(),
            };
          }).toList();

      final formData = FormData.fromMap({
        "user_id": userId,
        "name": name,
        "phone": phone,
        "address": address,
        "payment_method": "cod",
        "cart": jsonEncode(cartPayload),
      });

      final response = await Config.dio.post(
        '/${ApiPath.placeOrder}',
        data: formData,
        options: Options(headers: {"Content-Type": "multipart/form-data"}),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        AppToast.success("Order placed successfully");
        clearCart();
        Get.offNamed(Routes.ORDERS);
      } else {
        AppToast.error(response.data['message'] ?? "Order failed");
      }
    } catch (e) {
      AppToast.error("Error: $e");
    } finally {
      placingOrder.value = false;
    }
  }
}
