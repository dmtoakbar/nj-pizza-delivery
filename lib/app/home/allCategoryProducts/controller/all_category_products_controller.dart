import 'package:get/get.dart';
import '../../../../api/api_path.dart';
import '../../../../api/config.dart';
import '../../../../utils/app_toast.dart';
import '../../home/model/categories_model.dart';
import '../../home/model/product-model.dart';

class AllCategoryProductsController extends GetxController {
  RxBool loading = false.obs;

  final categories = <CategoriesModel>[].obs;

  /// categoryId -> products
  final categoryProducts = <String, List<ProductModel>>{}.obs;

  /// categoryId -> total count
  final categoryTotalCount = <String, int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadCategoriesWithProducts();
  }

  Future<void> loadCategoriesWithProducts() async {
    loading.value = true;
    try {
      // 1️⃣ Load categories
      final catRes =
      await Config.dio.get('/${ApiPath.productCategoryList}');

      if (catRes.data['success'] == true) {
        final List list = catRes.data['data'];
        categories.assignAll(
          list.map((e) => CategoriesModel.fromJson(e)).toList(),
        );

        // 2️⃣ Load 10 products for each category
        for (final cat in categories) {
          await loadCategoryProducts(cat.id);
        }
      }
    } catch (e) {
      AppToast.error('Failed loading categories');
    } finally {
      loading.value = false;
    }
  }

  Future<void> loadCategoryProducts(String categoryId) async {
    try {
      final res = await Config.dio.get(
        '/${ApiPath.products}',
        queryParameters: {
          'category_id': categoryId,
          'limit': 10,
          'page': 1,
        },
      );

      if (res.data['success'] == true) {
        final List list = res.data['data'];

        categoryProducts[categoryId] =
            list.map((e) => ProductModel.fromJson(e)).toList();

        categoryTotalCount[categoryId] =
        res.data['pagination']['total'];
      }
    } catch (e) {
      AppToast.error('Failed loading products');
    }
  }


  bool hasMore(String categoryId) {
    final loaded = categoryProducts[categoryId]?.length ?? 0;
    final total = categoryTotalCount[categoryId] ?? 0;
    return total > loaded;
  }
}

