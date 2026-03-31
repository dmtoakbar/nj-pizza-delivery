import 'package:get/get.dart';
import 'package:nj_pizza_delivery/app/onboard/controller/onboard_controller.dart';

class OnboardControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingController>(() => OnboardingController());
  }

}