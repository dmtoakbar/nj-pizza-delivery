import 'package:get/get.dart';
import 'package:nj_pizza_delivery/app/home/pizaa/controller/pizza_slider_controller.dart';

class PizzaSlideControllerBinding extends Bindings {
  @override
  void dependencies() {
   Get.lazyPut<PizzaSliderController>(() => PizzaSliderController());
  }
}