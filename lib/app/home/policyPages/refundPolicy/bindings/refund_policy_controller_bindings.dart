import 'package:get/get.dart';
import 'package:nj_pizza_delivery/app/home/policyPages/refundPolicy/controller/refund_policy_controller.dart';

class RefundPolicyControllerBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RefundPolicyController>(() => RefundPolicyController());
  }
}
