import 'package:get/get.dart';
import 'package:nj_pizza_delivery/app/splash/controller/splash_controller.dart';

class SplashControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController());
  }
}