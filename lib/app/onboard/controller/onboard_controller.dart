import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class OnboardingController extends GetxController {
  void onCreateAccount() {
    Get.toNamed(Routes.REGISTRATION);
  }

  void onSignIn() {
    Get.toNamed(Routes.LOGIN);
  }

  void onSkip() {
    Get.toNamed(Routes.HOME);
  }
}
