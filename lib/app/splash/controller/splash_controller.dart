import 'package:get/get.dart';
import 'dart:async';

import 'package:nj_pizza_delivery/routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _startTimer();
  }

  void _startTimer() {
    // Wait 3 seconds then navigate to Login
    Timer(const Duration(seconds: 10), () {
      Get.offAllNamed(Routes.LOGIN);
    });
  }
}
