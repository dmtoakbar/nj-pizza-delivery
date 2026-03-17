import 'package:get/get.dart';
import 'package:nj_pizza_delivery/app/home/specifyCategoryProducts/controller/search_controller.dart';

import '../controller/specific_category_products_controller.dart';

class SpecificCategoryProductsControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SpecificCategoryProductsController>(
          () => SpecificCategoryProductsController(),
    );

    Get.lazyPut<SpecificCategorySearchController>(
          () => SpecificCategorySearchController(),
    );
  }
}
