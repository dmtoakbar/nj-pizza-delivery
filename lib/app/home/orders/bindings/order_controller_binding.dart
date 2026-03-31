import 'package:get/get.dart';
import 'package:nj_pizza_delivery/app/home/orders/controller/orders_controller.dart';

class OrderControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderController>(() => OrderController());
  }
}
