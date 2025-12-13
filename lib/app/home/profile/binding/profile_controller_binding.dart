import 'package:get/get.dart';
import 'package:nj_pizza_delivery/app/home/profile/controller/profile_controller.dart';

class ProfileControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
