import 'package:get/get.dart';
import 'package:nj_pizza_delivery/app/home/aboutMenu/controller/about_menu_controller.dart';
import 'package:nj_pizza_delivery/app/home/aboutMenu/controller/pizza_topping_controller.dart';

class AboutMenuControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AboutMenuController>(() => AboutMenuController());
    Get.lazyPut<PizzaToppingController>(() => PizzaToppingController());
  }
}