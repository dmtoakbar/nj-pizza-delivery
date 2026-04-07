import 'package:get/get.dart';
import 'package:nj_pizza_delivery/utils/app_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../api/api_path.dart';
import '../../../../api/config.dart';

class ProductReviewController extends GetxController {
  final String productId;

  ProductReviewController({required this.productId});

  var isLoading = true.obs;
  var avgRating = 0.0.obs;
  var totalReviews = 0.obs;
  var reviews = <Map<String, dynamic>>[].obs;
  var rating = 0.obs;
  var reviewText = ''.obs;

  var ratingError = false.obs;
  var reviewError = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAll();
  }

  Future<void> fetchAll() async {
    try {
      isLoading.value = true;
      await Future.wait([fetchSummary(), fetchReviews()]);
    } catch (e) {
      AppToast.error("Failed to load reviews");
    } finally {
      isLoading.value = false;
    }
  }

  /// ⭐ FETCH RATING SUMMARY
  Future<void> fetchSummary() async {
    try {
      final res = await Config.dio.get(
        '/${ApiPath.getProductRatingSummary}',
        queryParameters: {"product_id": productId},
      );

      if (res.data['success'] == true) {
        final data = res.data['data'];

        avgRating.value = (data['avg_rating'] ?? 0).toDouble();
        totalReviews.value = data['total_reviews'] ?? 0;
      }
    } catch (e) {
      print("Summary error: $e");
    }
  }

  void setRating(int value) {
    rating.value = value;
    ratingError.value = false;
  }

  void setReview(String value) {
    reviewText.value = value;
    if (value.isNotEmpty) {
      reviewError.value = false;
    }
  }

  bool validate() {
    bool isValid = true;

    if (rating.value == 0) {
      ratingError.value = true;
      isValid = false;
    }

    if (reviewText.value.isEmpty) {
      reviewError.value = true;
      isValid = false;
    }

    return isValid;
  }

  void submit(ProductReviewController controller) {
    if (!validate()) return;

    controller.submitReview(rating.value, reviewText.value);

    Get.back();
  }

  /// 📝 FETCH REVIEWS LIST
  Future<void> fetchReviews() async {
    try {
      final res = await Config.dio.get(
        '/${ApiPath.getProductReview}',
        queryParameters: {"product_id": productId},
      );

      if (res.data['success'] == true) {
        reviews.value = List<Map<String, dynamic>>.from(res.data['data'] ?? []);
      }
    } catch (e) {
      print("Reviews error: $e");
    }
  }

  /// ✍️ SUBMIT REVIEW
  Future<void> submitReview(int rating, String review) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id') ?? '';

      final res = await Config.dio.post(
        '/${ApiPath.addProductReview}',
        data: {
          "user_id": userId,
          "product_id": productId,
          "rating": rating,
          "review": review,
        },
      );

      if (res.data['success'] == true) {
        AppToast.success(res.data['message'] ?? "Review submitted");

        fetchAll();
      } else {
        AppToast.error(res.data['message'] ?? "Failed");
      }
    } catch (e) {
      AppToast.error("Something went wrong");
    }
  }
}
