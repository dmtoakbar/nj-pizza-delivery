import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nj_pizza_delivery/app/home/widgets/headerWithBackButton/header_with_back_button.dart';
import 'controller/order_detail_controller.dart';

class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrderDetailsController());
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 8),
          CustomHeader(title: 'Order Detail', showFavorite: false),
          Expanded(
            child: Obx(() {
              if (controller.loading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.orange),
                );
              }

              if (controller.items.isEmpty) {
                return const Center(
                  child: Text(
                    "No items found",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                );
              }

              return SafeArea(
                top: false,
                bottom: true,
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ================= USER INFO CARD =================
                            Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 8,
                              margin: const EdgeInsets.only(bottom: 16),
                              shadowColor: Colors.black38,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Customer Info",
                                      style: GoogleFonts.poppins(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    _infoRow(
                                      Icons.person,
                                      controller.orderData['username'],
                                    ),
                                    const SizedBox(height: 6),
                                    _infoRow(
                                      Icons.phone,
                                      controller.orderData['phone'],
                                    ),
                                    const SizedBox(height: 6),
                                    _infoRow(
                                      Icons.email,
                                      controller.orderData['email'],
                                    ),
                                    const SizedBox(height: 6),
                                    _infoRow(
                                      Icons.location_on,
                                      controller.orderData['address'],
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.payment,
                                          size: 18,
                                          color: Colors.deepOrange,
                                        ),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            "Payment: ${controller.orderData['payment_method'] ?? ''} | Status: ${controller.orderData['status'] ?? ''}",
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // ================= ORDER ITEMS CARD =================
                            Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 8,
                              shadowColor: Colors.black38,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: List.generate(controller.items.length, (
                                    index,
                                  ) {
                                    final item = controller.items[index];
                                    return Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Product image
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: Image.network(
                                                item.image,
                                                width: 70,
                                                height: 70,
                                                fit: BoxFit.cover,
                                                errorBuilder:
                                                    (_, __, ___) => Container(
                                                      width: 70,
                                                      height: 70,
                                                      color:
                                                          Colors.grey.shade300,
                                                      child: const Icon(
                                                        Icons.image,
                                                        size: 30,
                                                      ),
                                                    ),
                                              ),
                                            ),
                                            const SizedBox(width: 14),

                                            // Item details
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  // Product name
                                                  Text(
                                                    item.name,
                                                    style: GoogleFonts.poppins(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),

                                                  // Quantity × Base Price
                                                  Text(
                                                    "Qty: ${item.quantity} × \$${item.finalPrice.toStringAsFixed(0)}",
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 13,
                                                      color:
                                                          Colors.grey.shade700,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),

                                                  // Size and size price
                                                  Text(
                                                    "Size: ${item.size} ${item.finalPrice > 0 ? "(+\$${item.finalPrice.toStringAsFixed(0)})" : ""}",
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 13,
                                                      color:
                                                          Colors.grey.shade700,
                                                    ),
                                                  ),

                                                  // Extras
                                                  if (item
                                                      .extras
                                                      .isNotEmpty) ...[
                                                    const SizedBox(height: 6),
                                                    Wrap(
                                                      spacing: 6,
                                                      runSpacing: 4,
                                                      children:
                                                          item.extras.map((
                                                            extra,
                                                          ) {
                                                            return Container(
                                                              padding:
                                                                  const EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        8,
                                                                    vertical: 4,
                                                                  ),
                                                              decoration: BoxDecoration(
                                                                color:
                                                                    Colors
                                                                        .orange
                                                                        .shade100,
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      8,
                                                                    ),
                                                              ),
                                                              child: Text(
                                                                "+ ${extra.name} \$${extra.price.toStringAsFixed(0)}",
                                                                style: GoogleFonts.poppins(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color:
                                                                      Colors
                                                                          .deepOrange,
                                                                ),
                                                              ),
                                                            );
                                                          }).toList(),
                                                    ),
                                                  ],
                                                ],
                                              ),
                                            ),

                                            const SizedBox(width: 8),

                                            // Total price for this item
                                            Text(
                                              "\$${item.totalPrice.toStringAsFixed(0)}",
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (index !=
                                            controller.items.length - 1)
                                          const Divider(
                                            height: 28,
                                            thickness: 1.2,
                                          ),
                                      ],
                                    );
                                  }),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),

                    // ================= TOTAL SECTION =================
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            offset: const Offset(0, -3),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total Amount",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "\$${controller.totalAmount.toStringAsFixed(0)}",
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // Helper for user info rows
  Widget _infoRow(IconData icon, String? value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.deepOrange),
        const SizedBox(width: 6),
        Expanded(
          child: Text(value ?? '', style: GoogleFonts.poppins(fontSize: 14)),
        ),
      ],
    );
  }
}
