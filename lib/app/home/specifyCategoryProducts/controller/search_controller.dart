import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:nj_pizza_delivery/api/search_api.dart';
import 'package:nj_pizza_delivery/app/home/specifyCategoryProducts/controller/specific_category_products_controller.dart';
import 'package:flutter/material.dart';

class SpecificCategorySearchController extends GetxController {
  final controller = Get.find<SpecificCategoryProductsController>();
  final isSearching = false.obs;
  CancelToken? _cancelToken;
  int _requestId = 0;

  final isLoading = false.obs;
  final textController = TextEditingController();

  // ---------------- SEARCH ----------------
  final searchQuery = ''.obs;
  void updateSearch(String value) => searchQuery.value = value;

  // ---------------- INIT ----------------
  @override
  void onInit() {
    super.onInit();
    debounce(
      searchQuery,
      (_) => search(),
      time: const Duration(milliseconds: 500),
    );
  }

  Future<void> search() async {
    if (searchQuery.value.isEmpty) {
      isSearching.value = false;
      controller.loadProduct(isRefresh: true);
      return;
    }

    isSearching.value = true;
    isLoading.value = true;

    final int currentRequest = ++_requestId;

    _cancelToken?.cancel();
    _cancelToken = CancelToken();

    final params = {
      'category_id': controller.categoryId,
      'q': searchQuery.value,
    };

    try {
      final data = await SearchApi.search(params, cancelToken: _cancelToken);

      // ✅ only apply if this is the latest request
      if (currentRequest == _requestId) {
        controller.products
          ..clear()
          ..addAll(data);

        // ⛔ stop pagination
        controller.hasMore.value = false;
      }
    } on DioException catch (e) {
      if (!CancelToken.isCancel(e) && currentRequest == _requestId) {
        controller.products.clear();
      }
    } finally {
      // ✅ only hide loader for latest request
      if (currentRequest == _requestId) {
        isLoading.value = false;
      }
    }
  }

  @override
  void onClose() {
    _cancelToken?.cancel();
    textController.dispose();
    super.onClose();
  }
}
