import 'package:get/get.dart';
import 'package:nj_pizza_delivery/app/home/home/controller/home_controller.dart';
import 'package:nj_pizza_delivery/app/home/myFavourite/controller/my_favourite_controller.dart';
import 'package:nj_pizza_delivery/app/home/profile/controller/profile_controller.dart';
import '../controller/search_controller.dart';

class HomeControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ProfileController>(ProfileController(), permanent: true);
    Get.put<FavoritesController>(FavoritesController(), permanent: true);
    // screen-scoped
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<SearchHomeController>(() => SearchHomeController());
  }
}
