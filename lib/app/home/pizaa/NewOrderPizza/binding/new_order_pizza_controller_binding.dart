import 'package:get/get.dart';
import 'package:nj_pizza_delivery/app/home/pizaa/NewOrderPizza/controller/new_pizza_order.dart';

class NewOrderPizzaControllerBinding extends Bindings {
  @override
  void dependencies() {
     Get.lazyPut<NewPizzaOrderController>(() => NewPizzaOrderController());
  }
}