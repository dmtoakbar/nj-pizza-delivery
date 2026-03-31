import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:nj_pizza_delivery/api/search_api.dart';
import 'package:nj_pizza_delivery/app/home/home/model/product-model.dart';
import 'package:flutter/material.dart';

class AllCategorySearchController extends GetxController {
  CancelToken? _cancelToken;
  int _requestId = 0;
  final textController = TextEditingController();

  RxList<ProductModel> searchProducts = <ProductModel>[].obs;

  final isLoading = false.obs;

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
      searchProducts.clear();
      return;
    }

    isLoading.value = true;

    final int currentRequest = ++_requestId;

    _cancelToken?.cancel();
    _cancelToken = CancelToken();

    final params = {'q': searchQuery.value};

    try {
      final data = await SearchApi.search(params, cancelToken: _cancelToken);

      // ✅ only apply if this is the latest request
      if (currentRequest == _requestId) {
        searchProducts
          ..clear()
          ..addAll(data);
      }
    } on DioException catch (e) {
      if (!CancelToken.isCancel(e) && currentRequest == _requestId) {
        searchProducts.clear();
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
