import 'package:get/get.dart';
import 'package:nj_pizza_delivery/app/home/policyPages/cancellationPolicy/controller/cancellation_policy_controller.dart';

class CancellationPolicyControllerBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CancellationPolicyController>(() => CancellationPolicyController());
  }
}
