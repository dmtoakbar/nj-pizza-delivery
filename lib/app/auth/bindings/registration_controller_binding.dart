import 'package:get/get.dart';
import 'package:nj_pizza_delivery/app/auth/controllers/registrationController.dart';

class RegistrationControllerBinding extends Bindings {
  @override
  void dependencies() {
   Get.lazyPut<RegistrationController>(() => RegistrationController());
  }
}