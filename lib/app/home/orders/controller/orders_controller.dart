import 'package:get/get.dart';
import 'package:nj_pizza_delivery/api/api_path.dart';
import 'package:nj_pizza_delivery/api/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/order_model.dart';


class OrderController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<OrderModel> orders = <OrderModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrderHistory();
  }

  Future<void> fetchOrderHistory() async {
    try {
      isLoading.value = true;

      final prefs = await SharedPreferences.getInstance();
      final userEmail = prefs.getString('user_email');

      if (userEmail == null || userEmail.isEmpty) {
        return;
      }

      final response = await Config.dio.get(
        '/${ApiPath.orderHistory}',
        queryParameters: {'email': userEmail},
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List list = response.data['orders'];
        orders.assignAll(
          list.map((e) => OrderModel.fromJson(e)).toList(),
        );
      }
    } catch (e) {
      print("Order history error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
