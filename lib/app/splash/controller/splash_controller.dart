import 'package:get/get.dart';
import 'dart:async';
import 'package:nj_pizza_delivery/routes/app_routes.dart';
import 'package:nj_pizza_delivery/utils/auth_service.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateAfterDelay();
  }

  void _navigateAfterDelay() async {
    try {
      final isLoggedIn = await AuthService.isLoggedIn();
      await Future.delayed(const Duration(seconds: 3));

      if (isLoggedIn == true) {
        Get.offAllNamed(Routes.HOME);
      } else {
        Get.offAllNamed(Routes.LOGIN);
      }
    } catch (e) {
      Get.offAllNamed(Routes.LOGIN);
    }
  }
}

