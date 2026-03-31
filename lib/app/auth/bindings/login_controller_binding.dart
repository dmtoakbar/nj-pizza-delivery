import 'package:get/get.dart';
import 'package:nj_pizza_delivery/app/auth/controllers/loginController.dart';

class LoginControllerBinding extends Bindings {
  @override
  void dependencies() {
   Get.lazyPut<LoginController>(() => LoginController());
  }

}