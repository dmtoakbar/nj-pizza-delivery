import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static final String baseUrl = dotenv.env['BASE_URL'] ?? '';
  static final String apiBasePath = dotenv.env['API_BASE_PATH'] ?? '';
  static final String apiVersion = dotenv.env['API_VERSION'] ?? '';
  static final String apiKey = dotenv.env['API_KEY'] ?? '';

  static String get apiUrl {
    return '$baseUrl/$apiBasePath/$apiVersion';
  }

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: apiUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'X-API-KEY': apiKey,
        'Accept': 'application/json',
      },
      validateStatus: (status) => true,
    ),
  )..interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        if (kDebugMode) {
          debugPrint('➡️ URL: ${options.uri}');
          debugPrint('➡️ HEADERS: ${options.headers}');
          debugPrint('➡️ DATA: ${options.data}');
        }
        handler.next(options);
      },
      onResponse: (response, handler) {
        if (kDebugMode) {
          debugPrint('✅ STATUS: ${response.statusCode}');
          debugPrint('✅ RESPONSE: ${response.data}');
        }
        handler.next(response);
      },
      onError: (e, handler) {
        debugPrint('❌ DIO ERROR: ${e.message}');
        handler.next(e);
      },
    ),
  );

}
