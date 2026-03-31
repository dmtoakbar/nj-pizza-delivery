import 'package:get/get.dart';
import 'package:nj_pizza_delivery/app/auth/controllers/forget_password_controller.dart';


class ForgetPasswordControllerBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<ForgetPasswordController>(() => ForgetPasswordController());
  }

}