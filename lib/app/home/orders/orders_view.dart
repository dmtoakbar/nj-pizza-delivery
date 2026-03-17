import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nj_pizza_delivery/app/home/orders/controller/orders_controller.dart';
import 'package:nj_pizza_delivery/app/home/orders/widgets/order_card_widget.dart';
import '../../../routes/app_routes.dart';
import '../widgets/appBar/header.dart';
import '../widgets/appBar/widgets/side_bar.dart';
import '../widgets/bottomAppBar/animated_bottom_nav.dart';

class OrdersView extends GetView<OrderController> {
  OrdersView({super.key});

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
        drawer: SideMenuWidget(),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Header(),
              ),
              const SizedBox(height: 4),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.orange),
                    );
                  }

                  if (controller.orders.isEmpty) {
                    return const Center(
                      child: Text(
                        "No orders found",
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: controller.orders.length,
                    itemBuilder: (context, index) {
                      final order = controller.orders[index];

                      return OrderCard(
                        orderId: order.orderId,
                        createdAt: order.createdAt,
                        totalAmount: order.totalAmount,
                        status: order.status,
                        paymentStatus: order.paymentStatus,
                        onTap: () {
                          Get.toNamed(
                            Routes.ORDERDETAIL,
                            arguments: {'order_id': order.orderId},
                          );
                        },
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const AnimatedBottomNav(),
      ),
    );
  }
}
