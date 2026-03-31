import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nj_pizza_delivery/app/auth/widgets/app_text_field.dart';
import 'package:nj_pizza_delivery/app/home/cart/controller/cart_controller.dart';
import 'package:nj_pizza_delivery/utils/app_toast.dart';
import 'controller/place_order_controller.dart';
import 'model/address_model.dart';

class PlaceOrderView extends StatelessWidget {
  PlaceOrderView({super.key});

  final c = Get.put(PlaceOrderController());
  final cartController = Get.find<CartController>();

  static const _labels = ['Home', 'Office', 'Other'];

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
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 140), // IMPORTANT
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _header(),
                  SizedBox(height: 20),
                  _title(),
                  const SizedBox(height: 20),
                  _addressSection(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),

        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _orderSummary(),
                const SizedBox(height: 10),
                _placeOrderButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _header() {
    return Row(
      children: [
        InkWell(
          onTap: () => Get.back(),
          child: const Icon(Icons.arrow_back_ios, size: 18),
        ),
        const Spacer(),
        const Text(
          'Place Order',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const Spacer(),
        SizedBox(),
      ],
    );
  }

  Widget _title() => const Text(
    "Place Your Order",
    style: TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.bold,
      color: Colors.deepOrange,
    ),
  );

  /// ================= ADDRESS SECTION =================
  Widget _addressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              "Delivery Address",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            TextButton.icon(
              style: TextButton.styleFrom(
                backgroundColor: Colors.deepOrange.withOpacity(0.1),
                foregroundColor: Colors.deepOrange,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
              onPressed: () => _openAddressSheet(),
              icon: const Icon(Icons.add),
              label: const Text("Add New"),
            ),
          ],
        ),
        const SizedBox(height: 12),

        /// ❌ Only wrap the address list in Obx
        Obx(() {
          if (c.addresses.isEmpty) {
            return Container(
              margin: EdgeInsetsGeometry.only(top: 50),
              padding: const EdgeInsets.symmetric(vertical: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Text("No address added yet"),
            );
          }

          return Column(
            children: List.generate(c.addresses.length, (i) {
              final a = c.addresses[i];
              final selected = c.selectedIndex.value == i;

              return GestureDetector(
                onTap: () => c.selectAddress(i),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color:
                          selected ? Colors.deepOrange : Colors.grey.shade300,
                      width: selected ? 1.8 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Radio(
                        value: i,
                        groupValue: c.selectedIndex.value,
                        activeColor: Colors.deepOrange,
                        onChanged: (_) => c.selectAddress(i),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "${_icon(a.label)} ${a.label}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Spacer(),
                                PopupMenuButton(
                                  icon: const Icon(Icons.more_vert, size: 18),
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(
                                      color: Colors.orange,
                                      width: 1,
                                    ),
                                  ),
                                  itemBuilder:
                                      (_) => const [
                                        PopupMenuItem(
                                          value: 'edit',
                                          child: Text("Edit"),
                                        ),
                                        PopupMenuItem(
                                          value: 'delete',
                                          child: Text("Delete"),
                                        ),
                                      ],
                                  onSelected: (v) {
                                    if (v == 'edit') {
                                      _openAddressSheet(index: i);
                                    } else {
                                      c.deleteAddress(i);
                                    }
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(a.name),
                            Text(a.phone),
                            const SizedBox(height: 4),
                            Text(
                              a.address,
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          );
        }),
      ],
    );
  }

  String _icon(String label) {
    switch (label.toLowerCase()) {
      case 'home':
        return '🏠';
      case 'office':
        return '🏢';
      default:
        return '📍';
    }
  }

  /// ================= ORDER SUMMARY =================
  Widget _orderSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Total Amount",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Obx(
            () => Text(
              "\$${cartController.getTotalPrice().toStringAsFixed(2)}",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sheetInput(
    TextEditingController controller, {
    String label = '',
    TextInputType type = TextInputType.text,
    int maxLines = 1,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: AppTextField(
      controller: controller,
      hintText: label,
      keyboardType: type,
      maxLines: maxLines,
    ),
  );

  /// ================= PLACE ORDER =================
  Widget _placeOrderButton() {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          onPressed:
              cartController.placingOrder.value
                  ? () {}
                  : () {
                    if (c.addresses.isEmpty) {
                      AppToast.error("Please add an address");
                      return;
                    }

                    final a = c.addresses[c.selectedIndex.value];
                    cartController.placeOrder(
                      name: a.name,
                      phone: a.phone,
                      address: a.address,
                    );
                  },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepOrange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child:
              cartController.placingOrder.value
                  ? Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                  : const Text(
                    "Place Order",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
        ),
      ),
    );
  }

  /// ================= ADDRESS BOTTOM SHEET =================
  void _openAddressSheet({int? index}) {
    if (index != null) {
      final a = c.addresses[index];
      c.label.value = a.label;
      c.addressNameController.text = a.name;
      c.addressPhoneController.text = a.phone;
      c.addressController.text = a.address;
    } else {
      c.label.value = 'Home';
      c.addressNameController.clear();
      c.addressPhoneController.clear();
      c.addressController.clear();
    }

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                "Address Type",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),

              /// 🔹 LABEL SELECTION - SINGLE OBX
              Obx(() {
                return Wrap(
                  spacing: 10,
                  children:
                      _labels.map((label) {
                        final selected = c.label.value == label;

                        return ChoiceChip(
                          label: Text(
                            label,
                            style: TextStyle(
                              color:
                                  selected
                                      ? Colors.white
                                      : Colors.deepOrange.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          checkmarkColor: Colors.white,
                          selected: selected,
                          selectedColor:
                              Colors
                                  .deepOrange, // filled deep orange when selected
                          backgroundColor:
                              Colors
                                  .deepOrange
                                  .shade50, // light orange when not selected
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color:
                                  selected
                                      ? Colors.deepOrange
                                      : Colors.deepOrange.shade200,
                            ),
                          ),
                          onSelected: (_) => c.label.value = label,
                        );
                      }).toList(),
                );
              }),

              const SizedBox(height: 16),
              _sheetInput(c.addressNameController, label: "Full Name"),
              _sheetInput(
                c.addressPhoneController,
                label: "Phone Number",
                type: TextInputType.phone,
              ),
              _sheetInput(
                c.addressController,
                label: "Full Address",
                maxLines: 1,
              ),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed:  () {
                    if (c.addressNameController.text.trim().isEmpty) {
                      AppToast.error('Please enter full name');
                      return;
                    }

                    if (c.addressPhoneController.text.trim().length != 10) {
                      AppToast.error("Phone number must be exactly 10 digits");
                      return;
                    }

                    if (c.addressController.text.trim().isEmpty) {
                      AppToast.error("Please enter address");
                      return;
                    }
                    final model = AddressModel(
                      label: c.label.value,
                      name: c.addressNameController.text,
                      phone: c.addressPhoneController.text,
                      address: c.addressController.text,
                    );

                    index != null
                        ? c.updateAddress(index, model)
                        : c.addAddress(model);
                    Get.back();
                  },
                  child: const Text(
                    "Save Address",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

}
