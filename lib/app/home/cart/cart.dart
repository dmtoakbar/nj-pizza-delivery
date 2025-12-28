import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nj_pizza_delivery/app/home/cart/controller/cart_controller.dart';
import 'package:nj_pizza_delivery/app/home/cart/model/cart_item.dart';
import 'package:nj_pizza_delivery/app/home/widgets/appBar/app_bar_widget.dart';

class CartScreen extends StatelessWidget {
  final controller = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    final components = appBarBundle();
    return Scaffold(
      appBar: components.appBar,
      drawer: components.drawer,
      backgroundColor: const Color(0xFFFDFAF5),
      body: Obx(
        () =>
            controller.items.isEmpty
                ? const Center(
                  child: Text(
                    "Your cart is empty",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
                : controller.checkOuting.value
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Order submitting to Pizza Hub!',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12),
                      CircularProgressIndicator(color: Colors.deepOrange),
                    ],
                  ),
                )
                : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: controller.items.length,
                        itemBuilder: (context, index) {
                          final item = controller.items[index];
                          return _cartItemCard(item, index);
                        },
                      ),
                    ),
                    _cartSummary(),
                  ],
                ),
      ),
    );
  }

  Widget _cartItemCard(CartItem item, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Pizza Image
          SizedBox(
            width: 58,
            height: 58,
            child: ClipOval(child: Image.asset(item.image, fit: BoxFit.cover)),
          ),
          const SizedBox(width: 12),

          // Name & Price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "\$${item.price.toStringAsFixed(2)}",
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),

          // Quantity Controls
          Row(
            children: [
              IconButton(
                onPressed: () => controller.decreaseQuantity(index),
                icon: const Icon(
                  Icons.remove_circle_outline,
                  color: Colors.deepOrange,
                ),
              ),
              Text(
                item.quantity.toString(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () => controller.increaseQuantity(index),
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: Colors.deepOrange,
                ),
              ),
            ],
          ),

          // Remove Button
          IconButton(
            onPressed: () => controller.removeItem(index),
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
          ),
        ],
      ),
    );
  }

  Widget _cartSummary() {
    return Obx(
      () => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 5,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "\$${controller.totalPrice.toStringAsFixed(2)}",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  controller.checkOuting.value ? null : controller.checkOut();
                },
                child:
                    controller.checkOuting.value
                        ? Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        )
                        : const Text(
                          "Checkout",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
