import 'package:get/get.dart';
import 'package:nj_pizza_delivery/app/home/cart/model/cart_item.dart';
import 'package:nj_pizza_delivery/constants/user_profile_data.dart';
import 'package:nj_pizza_delivery/emailService/send/order_send.dart';
import 'package:flutter/material.dart';

class CartController extends GetxController {
  var items = <CartItem>[].obs;

  RxBool checkOuting = false.obs;

  void addItem(CartItem item) {
    items.add(item);
    items.refresh();
  }

  void removeItem(int index) {
    items.removeAt(index);
    items.refresh();
  }

  void increaseQuantity(int index) {
    items[index].quantity++;
    items.refresh();
  }

  void decreaseQuantity(int index) {
    if (items[index].quantity > 1) {
      items[index].quantity--;
      items.refresh();
    }
  }

  void _showError(String message) {
    Get.snackbar(
      "Error",
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(12),
      icon: const Icon(Icons.error_outline, color: Colors.white),
    );
  }

  void _showSuccess(String message) {
    Get.snackbar(
      "Success",
      message,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(12),
      icon: const Icon(Icons.check_circle_outline, color: Colors.white),
    );
  }

  double get totalPrice =>
      items.fold(0, (sum, item) => sum + (item.price * item.quantity));

  Future<void> checkOut() async {
    if (items.isEmpty) {
      _showError('Please add some items');
      return;
    }

    try {
      checkOuting.value = true;
      userProfileData.dataLoaded ? null : await userProfileData.getUserData();

      final List<Map<String, dynamic>> orderItems =
          items.map((item) {
            return {
              'name': item.name,
              'quantity': item.quantity,
              'price': item.price,
            };
          }).toList();

      bool status = await sendOrderToAdmin(
        name: userProfileData.name,
        email: userProfileData.email,
        phone: userProfileData.mobile,
        address: userProfileData.address,
        orderItems: orderItems,
      );
      if (status) {
        _showSuccess("Your order has been submitted successfully!");
        items.clear();
      } else {
        _showError("Something went wrong!");
      }
    } catch (e) {
      _showError("Something went wrong!");
    } finally {
      checkOuting.value = false;
    }
  }
}
