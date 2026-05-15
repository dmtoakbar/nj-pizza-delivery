import 'package:get/get.dart';

import '../controller/menu_controller.dart';
import '../controller/menu_search_controller.dart';

class MenuControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainMenuController>(() => MainMenuController());

    Get.lazyPut<MenuSearchController>(() => MenuSearchController());
  }
}
