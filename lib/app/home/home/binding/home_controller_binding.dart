import 'package:get/get.dart';
import 'package:nj_pizza_delivery/app/home/home/controller/home_controller.dart';
import 'package:nj_pizza_delivery/app/home/profile/controller/profile_controller.dart';

class HomeControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(
          () => ProfileController(),
      fenix: true,
    );
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
