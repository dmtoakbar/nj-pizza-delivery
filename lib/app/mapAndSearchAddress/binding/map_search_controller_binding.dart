import 'package:get/get.dart';
import 'package:nj_pizza_delivery/app/mapAndSearchAddress/controller/map_search_controller.dart';

class MapSearchControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MapSearchController>(() => MapSearchController());
  }
}