import 'package:dio/dio.dart';
import 'package:nj_pizza_delivery/api/config.dart';
import 'package:nj_pizza_delivery/app/home/home/model/product-model.dart';
import 'api_path.dart';

class SearchApi {
  static Future<List<ProductModel>> search(
    Map<String, dynamic> params, {
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await DioClient.get(
        '/${ApiPath.search}',
        queryParameters: params,
        cancelToken: cancelToken,
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final list = response.data['data'] as List;
        return list.map((e) => ProductModel.fromJson(e)).toList();
      }

      return <ProductModel>[];
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) rethrow;
      throw Exception('Search: ${e.message}');
    }
  }
}

class DioClient {
  static Future<Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    return Config.dio.get(
      endpoint,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
    );
  }
}
