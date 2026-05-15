import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nj_pizza_delivery/app/home/myFavourite/model/my_favourite_product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../api/api_path.dart';
import '../../../../api/config.dart';
import '../../../../utils/app_toast.dart';
import '../../home/model/promo_sliders.dart';

class FavoritesController extends GetxController {
  final favorites = <MyFavouriteProductModel>[].obs;

  final RxList<PromoSliderModel> promoSliders = <PromoSliderModel>[].obs;

  RxBool promoSliderLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadPromoSliders();
    loadFavorites();
  }

  /* =========================
     LOAD FAVORITES
  ========================== */
  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList('favorites') ?? [];

    favorites.value =
        stored
            .map((e) => MyFavouriteProductModel.fromJson(jsonDecode(e)))
            .toList();
  }

  /* =========================
     ADD FAVORITE
  ========================== */
  Future<void> addFavorite(MyFavouriteProductModel product) async {
    if (!favorites.any((p) => p.id == product.id)) {
      favorites.add(product);
      await saveFavorites();
    }
  }

  /* =========================
     REMOVE FAVORITE
  ========================== */
  Future<void> removeFavorite(String productId) async {
    favorites.removeWhere((p) => p.id == productId);
    await saveFavorites();
  }

  /* =========================
     SAVE FAVORITES (SNAPSHOT)
  ========================== */
  Future<void> saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();

    final data =
        favorites.map((p) {
          return jsonEncode({
            'id': p.id,
            'category_id': p.categoryId,
            'name': p.name,
            'description': p.description,

            /// snapshot data (VERY IMPORTANT)
            'sizes': p.sizes,
            'discount_percentage': p.discountPercentage,
            'base_price': p.basePrice,
            'final_price': p.finalPrice,

            'image': p.image,
            'is_popular': p.isPopular ? 1 : 0,
            'is_featured': p.isFeatured ? 1 : 0,
          });
        }).toList();

    await prefs.setStringList('favorites', data);
  }

  /* =========================
     HELPERS
  ========================== */
  bool isFavorite(String productId) {
    return favorites.any((p) => p.id == productId);
  }

  void toggleFavorite(MyFavouriteProductModel product) {
    if (isFavorite(product.id)) {
      removeFavorite(product.id);
    } else {
      addFavorite(product);
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
