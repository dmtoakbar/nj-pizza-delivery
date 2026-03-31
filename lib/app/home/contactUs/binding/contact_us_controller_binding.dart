import 'package:get/get.dart';
import 'package:nj_pizza_delivery/app/home/contactUs/controller/contact_us_controller.dart';

class ContactUsControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContactUsController>(() => ContactUsController());
  }
}
