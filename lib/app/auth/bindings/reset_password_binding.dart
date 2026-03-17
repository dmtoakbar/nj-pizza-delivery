import 'package:get/get.dart';
import '../controllers/verify_opt_and_update_password_controller.dart';

class ResetPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ResetPasswordController>(
          () => ResetPasswordController(Get.arguments as String),
    );
  }
}