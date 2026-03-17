import 'package:get/get.dart';
import 'package:nj_pizza_delivery/app/home/policyPages/shippingPolicy/controller/shipping_policy_controller.dart';

class ShippingPolicyControllerBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShippingPolicyController>(() => ShippingPolicyController());
  }
}
