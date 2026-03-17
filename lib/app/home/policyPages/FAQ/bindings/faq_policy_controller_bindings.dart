import 'package:get/get.dart';
import 'package:nj_pizza_delivery/app/home/policyPages/FAQ/controller/faq_policy_controller.dart';

class FAQPolicyControllerBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FAQPolicyController>(() => FAQPolicyController());
  }
}
