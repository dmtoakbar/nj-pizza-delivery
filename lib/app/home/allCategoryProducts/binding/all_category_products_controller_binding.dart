import 'package:get/get.dart';
import 'package:nj_pizza_delivery/app/home/allCategoryProducts/controller/all_category_products_controller.dart';
import '../controller/search_controller.dart';

class AllCategoryProductsControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AllCategoryProductsController>(
      () => AllCategoryProductsController(),
    );
    Get.lazyPut<AllCategorySearchController>(
      () => AllCategorySearchController(),
    );
  }
}
