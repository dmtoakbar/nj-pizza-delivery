import 'package:get/get.dart';
import 'package:nj_pizza_delivery/app/home/report/controller/report_controller.dart';

class ReportControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportController>(() => ReportController());
  }
}
