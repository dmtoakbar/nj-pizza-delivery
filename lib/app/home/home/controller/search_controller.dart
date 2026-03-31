import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:nj_pizza_delivery/api/search_api.dart';
import 'package:nj_pizza_delivery/app/home/home/controller/home_controller.dart';
import 'package:nj_pizza_delivery/app/home/home/model/categories_model.dart';
import 'package:nj_pizza_delivery/app/home/home/model/product-model.dart';
import 'package:nj_pizza_delivery/utils/app_toast.dart';
import 'package:flutter/material.dart';

enum PriceSort { lowToHigh, highToLow }

class SearchHomeController extends GetxController {
  final HomeController controller = Get.find<HomeController>();
  final selectedCategory = 0.obs;
  final productLoadCategoryId = ''.obs;
  CancelToken? _cancelToken;
  int _requestId = 0;
  final textController = TextEditingController();

  final RxList<CategoriesModel> categories = <CategoriesModel>[].obs;
  final RxList<ProductModel> allProducts = <ProductModel>[].obs;

  final isLoading = false.obs;

  // ---------------- SEARCH ----------------
  final searchQuery = ''.obs;
  void updateSearch(String value) => searchQuery.value = value;

  // ---------------- PRICE RANGE ----------------
  final minPrice = 0.0.obs;
  final maxPrice = 1000.0.obs;
  void setPriceRange(double min, double max) {
    minPrice.value = min;
    maxPrice.value = max;
  }

  // ---------------- SORT ----------------
  final priceSort = Rx<PriceSort?>(null);
  void setPriceSort(PriceSort? sort) => priceSort.value = sort;

  // ---------------- TOGGLES ----------------
  final showPopularOnly = false.obs;
  final showFeaturedOnly = false.obs;

  void togglePopular() => showPopularOnly.toggle();
  void toggleFeatured() => showFeaturedOnly.toggle();

  // ---------------- INIT ----------------
  @override
  void onInit() {
    super.onInit();
    loadCategories();

    debounce(
      searchQuery,
      (_) => search(),
      time: const Duration(milliseconds: 500),
    );
  }

  Future<void> search() async {
    if (searchQuery.value.isEmpty) {
      _cancelToken?.cancel();
      allProducts.clear();
      isLoading.value = false;
      return;
    }

    final int currentRequest = ++_requestId;
    _cancelToken?.cancel();
    _cancelToken = CancelToken();
    isLoading.value = true;

    final params = <String, dynamic>{};
    params['q'] = searchQuery.value;

    if (productLoadCategoryId.value.isNotEmpty) {
      params['category_id'] = productLoadCategoryId.value;
    }

    params['min_price'] = minPrice.value.toInt();
    params['max_price'] = maxPrice.value.toInt();

    if (showPopularOnly.value) params['popular'] = 1;
    if (showFeaturedOnly.value) params['featured'] = 1;

    if (priceSort.value != null) {
      params['sort'] =
      priceSort.value == PriceSort.lowToHigh
          ? 'price_asc'
          : 'price_desc';
    }

    try {
      final data = await SearchApi.search(params, cancelToken: _cancelToken);

      if (currentRequest == _requestId) {
        allProducts.assignAll(data);
      }
    } finally {
      if (currentRequest == _requestId) {
        isLoading.value = false;
      }
    }
  }

  // ---------------- LOAD CATEGORIES ----------------
  Future<void> loadCategories() async {
    try {
      categories.clear();

      // Add "All" category
      categories.add(CategoriesModel.all());

      // Copy categories from HomeController
      categories.addAll(controller.categories.toList());
    } catch (e) {
      AppToast.error('Failed to load categories');
    }
  }

  // ---------------- CATEGORY SELECT ----------------
  void selectCategory(int index) {
    selectedCategory.value = index;
    productLoadCategoryId.value = categories[index].id;
  }

  bool isCategorySelected(int index) => selectedCategory.value == index;

  // ---------------- RESET ----------------
  void resetFilters() {
    searchQuery.value = '';
    selectedCategory.value = 0;
    minPrice.value = 0;
    maxPrice.value = 1000;
    priceSort.value = null;
    showPopularOnly.value = false;
    showFeaturedOnly.value = false;
  }

  @override
  void onClose() {
    _cancelToken?.cancel();
    //textController.dispose();
    super.onClose();
  }
}
