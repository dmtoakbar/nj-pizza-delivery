import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nj_pizza_delivery/app/home/home/model/product-model.dart';
import 'package:nj_pizza_delivery/app/home/specifyCategoryProducts/controller/search_controller.dart';
import '../../../../api/api_path.dart';
import '../../../../api/config.dart';
import '../../../../utils/app_toast.dart';

class SpecificCategoryProductsController extends GetxController {
  final searchText = ''.obs;

  RxBool mainPageLoading = false.obs;
  RxBool moreProductLoading = false.obs;

  RxInt page = 1.obs;
  RxBool hasMore = true.obs;

  RxList<ProductModel> products = <ProductModel>[].obs;

  late final String categoryId;
  late final String categoryName;

  late ScrollController scrollController;

  /// used only for deduplication
  final Set<String> _productIds = {};

  @override
  void onInit() {
    super.onInit();

    scrollController = ScrollController();
    scrollController.addListener(_onScroll);

    final args = Get.arguments as Map<String, dynamic>;
    categoryId = args['category_id'];
    categoryName = args['category_name'];

    loadProduct();
  }

  void _onScroll() {
    final isSearching =
        Get.find<SpecificCategorySearchController>().isSearching.value;

    if (isSearching) return; // ⛔ STOP pagination

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
          'category_id': categoryId,
          'page': page.value,
        },
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List list = response.data['data'];

        final fetched =
        list.map((e) => ProductModel.fromJson(e)).toList();

        /// 🔐 Deduplication by product ID
        final newProducts = fetched.where((p) {
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
