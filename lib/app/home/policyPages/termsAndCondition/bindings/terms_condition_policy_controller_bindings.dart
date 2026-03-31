import 'package:get/get.dart';
import 'package:nj_pizza_delivery/app/home/policyPages/termsAndCondition/controller/terms_condition_policy_controller.dart';

class TermsConditionPolicyControllerBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TermsConditionPolicyController>(() => TermsConditionPolicyController());
  }
}
