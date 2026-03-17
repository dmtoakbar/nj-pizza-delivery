import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/auth_service.dart';
import 'controller/cart_controller.dart';

enum _CartMenuAction { goToMenu, clearCart }

class CartScreen extends GetView<CartController> {
  const CartScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              _header(),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Obx(
                          () => IntrinsicHeight(
                            child: Column(
                              children: [
                                _orderList(),
                                const Spacer(),
                                if (controller.items.isNotEmpty) _summary(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Obx(
          () =>
              controller.items.isEmpty
                  ? const SizedBox()
                  : SafeArea(bottom: true, child: _bottomBar()),
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _header() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: Row(
        children: [
          InkWell(
            onTap: () => Get.back(),
            child: const Icon(Icons.arrow_back_ios, size: 18),
          ),
          const Spacer(),
          const Text(
            'My Cart',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          PopupMenuButton<_CartMenuAction>(
            icon: const Icon(Icons.more_horiz),
            elevation: 6,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            onSelected: (action) {
              switch (action) {
                case _CartMenuAction.clearCart:
                  controller.clearCart();
                  break;
                case _CartMenuAction.goToMenu:
                  Get.toNamed(Routes.HOME);
                  break;
              }
            },
            itemBuilder:
                (context) => [
                  const PopupMenuItem(
                    value: _CartMenuAction.goToMenu,
                    height: 44,
                    child: Row(
                      children: [
                        Icon(Icons.add_shopping_cart, size: 20),
                        SizedBox(width: 12),
                        Text(
                          'Add more items',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(height: 1),
                  const PopupMenuItem(
                    value: _CartMenuAction.clearCart,
                    height: 44,
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, size: 20, color: Colors.red),
                        SizedBox(width: 12),
                        Text(
                          'Clear cart',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
          ),
        ],
      ),
    );
  }

  // ================= ORDER LIST =================
  Widget _orderList() {
    if (controller.items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 120),
        child: Center(
          child: Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: List.generate(controller.items.length, (index) {
          final item = controller.items[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // IMAGE
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: CachedNetworkImage(
                        imageUrl: item.image,
                        height: 90,
                        width: 90,
                        fit: BoxFit.cover,
                        placeholder:
                            (context, url) =>
                                Container(color: Colors.grey.shade300),
                        errorWidget:
                            (context, url, error) =>
                                const Icon(Icons.image_not_supported),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // DETAILS
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Size: ${item.size}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children:
                                item.extras
                                    .map(
                                      (extra) => Text(
                                        "• ${extra.name} (+\$${extra.price.toStringAsFixed(2)})",
                                        style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                    )
                                    .toList(),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '\$${item.totalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _qtyButton(
                        icon: Icons.remove,
                        onTap: () => controller.decreaseQty(index),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          item.quantity.toString(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      _qtyButton(
                        icon: Icons.add,
                        onTap: () => controller.increaseQty(index),
                        filled: true,
                      ),
                      const SizedBox(width: 8),
                      _deleteButton(() => controller.removeItem(index)),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ================= SUMMARY =================
  Widget _summary() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 5),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Summary',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            _row('Subtotal', controller.subtotal),
            // _row('Tax', controller.tax),
            const SizedBox(height: 6),
            _row('Total Order', controller.total, bold: true),
          ],
        ),
      ),
    );
  }

  Widget _row(String title, double value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: bold ? Colors.black : Colors.grey,
              fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          const Spacer(),
          Text(
            '\$${value.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  // ================= BOTTOM BAR =================
  Widget _bottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Total Items: ${controller.items.length}',
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '\$${controller.total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () async {
              bool isLoggedIn = await AuthService.isLoggedIn();
              if (isLoggedIn) {
                Get.toNamed(Routes.PLACEORDER);
              } else {
                AuthService.checkLoginAndRedirect();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEB5525),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              'Place Order',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= BUTTONS =================
  Widget _qtyButton({
    required IconData icon,
    required VoidCallback onTap,
    bool filled = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 28,
        width: 28,
        decoration: BoxDecoration(
          color: filled ? const Color(0xFFFF6A3D) : const Color(0xFFEDEDED),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 16,
          color: filled ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget _deleteButton(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 28,
        width: 28,
        decoration: const BoxDecoration(
          color: Color(0xFFF2F2F2),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.delete_outline,
          size: 16,
          color: Color(0xFF9E9E9E),
        ),
      ),
    );
  }
}
