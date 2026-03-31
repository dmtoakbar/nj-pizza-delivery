import 'package:get/get.dart';
import 'package:nj_pizza_delivery/app/home/aboutUs/controller/about_us_controller.dart';

class AboutUsControllerBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AboutUsController>(() => AboutUsController());
  }
}
