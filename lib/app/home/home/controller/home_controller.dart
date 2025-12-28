import 'package:get/get.dart';

class HomeController extends GetxController {
  final cardScale = 0.9.obs;

  final isNavigating = false.obs;

  @override
  void onReady() {
    super.onReady();
    cardScale.value = 1.0;
  }

  void goToPizzaSlider() {
    if (isNavigating.value) return;
    isNavigating.value = true;

    Get.toNamed('/pizza-slider')?.then((_) {
      isNavigating.value = false;
    });
  }
}
