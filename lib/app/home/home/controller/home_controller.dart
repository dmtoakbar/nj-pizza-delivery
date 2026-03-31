import 'package:get/get.dart';
import 'package:nj_pizza_delivery/app/home/home/model/categories_model.dart';
import 'package:nj_pizza_delivery/app/home/home/model/home_banner.dart';
import 'package:nj_pizza_delivery/app/home/home/model/product-model.dart';
import 'package:nj_pizza_delivery/utils/app_toast.dart';
import '../../../../api/api_path.dart';
import '../../../../api/config.dart';

class HomeController extends GetxController {
  final RxList<HomeBannerModel> homeBannerList = <HomeBannerModel>[].obs;
  final selectedCategory = ''.obs;
  RxBool categoryFilterProductLoading = false.obs;

  RxBool isMainPageLoading = false.obs;

  final RxList<CategoriesModel> categories = <CategoriesModel>[].obs;

  final RxList<ProductModel> allProducts = <ProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadHomeData();
  }

  Future<void> loadHomeData() async {
    try {
      isMainPageLoading.value = true;

      await homeBanner();
      await loadCategories();

      if (categories.isNotEmpty) {
        selectedCategory.value = categories.first.id;
        await loadProduct();
      }
    } catch (e) {
      AppToast.error('Failed to load home data');
    } finally {
      isMainPageLoading.value = false;
    }
  }

  Future<void> homeBanner() async {
    try {
      final response = await Config.dio.get('/${ApiPath.homeBanners}');

      if (response.statusCode == 200 &&
          response.data != null &&
          response.data['success'] == true) {
        final data = response.data['data'];

        if (data is List && data.isNotEmpty) {
          final banners =
              data
                  .map((e) => HomeBannerModel.fromJson(e))
                  .toList()
                  .reversed
                  .toList();

          homeBannerList.assignAll(banners);
        } else {
          AppToast.error('No banners found');
        }
      }
    } catch (e) {
      print('HOME banner API ERROR: $e');
      AppToast.error('Failed home banner loading');
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

  Future<void> loadProduct() async {
    try {
      final response = await Config.dio.get(
        '/${ApiPath.products}',
        queryParameters: {'category_id': selectedCategory.value, 'popular': 1},
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List list = response.data['data'];

        final products = list.map((e) => ProductModel.fromJson(e)).toList();

        allProducts.clear();
        allProducts.assignAll(products);
      }
    } catch (e) {
      AppToast.error('Failed to load Products');
    } finally {
      categoryFilterProductLoading.value = false;
    }
  }

  void selectCategory(String index) {
    categoryFilterProductLoading.value = true;
    selectedCategory.value = index;
    loadProduct();
  }
}
