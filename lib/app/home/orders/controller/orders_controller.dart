import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nj_pizza_delivery/api/api_path.dart';
import 'package:nj_pizza_delivery/api/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../utils/app_toast.dart';
import '../../home/model/promo_sliders.dart';
import '../model/order_model.dart';


class OrderController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<OrderModel> orders = <OrderModel>[].obs;

  final RxList<PromoSliderModel> promoSliders = <PromoSliderModel>[].obs;

  RxBool promoSliderLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadPromoSliders();
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

  Future<void> loadPromoSliders() async {
    try {
      promoSliderLoading.value = true;

      final response = await Config.dio.get('/${ApiPath.promoSliders}');

      if (response.statusCode == 200 &&
          response.data != null &&
          response.data['success'] == true) {
        final data = response.data['data'];
        debugPrint('promo slider data ====================== $data');
        if (data is List && data.isNotEmpty) {
          final sliders =
          data.map((e) => PromoSliderModel.fromJson(e)).toList();

          promoSliders.assignAll(sliders);
        } else {
          promoSliders.clear();
        }
      }
    } catch (e) {
      print('PROMO SLIDER API ERROR: $e');

      AppToast.error('Failed to load promo sliders');
    } finally {
      promoSliderLoading.value = false;
    }
  }
}
