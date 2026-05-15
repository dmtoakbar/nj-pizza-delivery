import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nj_pizza_delivery/app/home/home/model/product-model.dart';
import 'package:nj_pizza_delivery/app/home/mainMenu/controller/menu_search_controller.dart';
import '../../../../api/api_path.dart';
import '../../../../api/config.dart';
import '../../../../utils/app_toast.dart';
import '../../home/model/categories_model.dart';

class MainMenuController extends GetxController {
  final searchText = ''.obs;
  RxBool initialDataLoading = false.obs;

  RxBool mainPageLoading = false.obs;
  RxBool moreProductLoading = false.obs;

  final selectedCategory = ''.obs;

  final RxList<CategoriesModel> categories = <CategoriesModel>[].obs;

  RxInt page = 1.obs;
  RxBool hasMore = true.obs;

  RxList<ProductModel> products = <ProductModel>[].obs;

  late ScrollController scrollController;

  final Set<String> _productIds = {};

  @override
  void onInit() {
    super.onInit();

    scrollController = ScrollController();
    scrollController.addListener(_onScroll);
    loadInitialData();
  }

  void _onScroll() {
    final isSearching = Get.find<MenuSearchController>().isSearching.value;

    if (isSearching) return;

    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200 &&
        !moreProductLoading.value &&
        !mainPageLoading.value &&
        hasMore.value) {
      loadProduct();
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  Future<void> loadInitialData() async {
    try {
      initialDataLoading.value = true;
      await loadCategories();
      await loadProduct();
    } finally {
      initialDataLoading.value = false;
    }
  }

  Future<void> loadCategories() async {
    try {
      final response = await Config.dio.get('/${ApiPath.productCategoryList}');

      if (response.statusCode == 200 &&
          response.data != null &&
          response.data['success'] == true) {
        final data = response.data['data'];

        if (data is List && data.isNotEmpty) {
          final apiCategories =
              data
                  .map((e) => CategoriesModel.fromJson(e))
                  .toList()
                  .reversed
                  .toList();

          categories.assignAll(apiCategories);
          selectedCategory.value = apiCategories.first.id;
        } else {
          AppToast.error('No categories found');
        }
      }
    } catch (e) {
      print('CATEGORY API ERROR: $e');
      AppToast.error('Failed loading category list');
    }
  }

  Future<void> changeCategory({required String id}) async {
    selectedCategory.value = id;
    loadProduct(isRefresh: true);
  }

  Future<void> loadProduct({bool isRefresh = false}) async {
    try {
      if (isRefresh) {
        page.value = 1;
        hasMore.value = true;
        products.clear();
        _productIds.clear();
      }

      if (!hasMore.value) return;

      if (page.value == 1) {
        mainPageLoading.value = true;
      } else {
        moreProductLoading.value = true;
      }

      final response = await Config.dio.get(
        '/${ApiPath.products}',
        queryParameters: {
          'category_id': selectedCategory.value,
          'page': page.value,
        },
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List list = response.data['data'];

        final fetched = list.map((e) => ProductModel.fromJson(e)).toList();

        /// 🔐 Deduplication by product ID
        final newProducts =
            fetched.where((p) {
              if (_productIds.contains(p.id)) return false;
              _productIds.add(p.id);
              return true;
            }).toList();

        if (newProducts.isEmpty) {
          hasMore.value = false;
        } else {
          products.addAll(newProducts);
          page.value++;
        }
      }
    } catch (e) {
      AppToast.error('Failed to load products');
    } finally {
      mainPageLoading.value = false;
      moreProductLoading.value = false;
    }
  }
}
