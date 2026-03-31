import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../../../api/api_path.dart';
import '../../../../../api/config.dart';

class TermsConditionPolicyController extends GetxController {
  final isLoading = false.obs;
  final title = ''.obs;
  final content = ''.obs;
  final lastUpdated = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadPolicy('terms-conditions');
  }

  Future<void> loadPolicy(String slug) async {
    try {
      isLoading.value = true;

      final response = await Config.dio.get(
        '/${ApiPath.policyPage}',
        queryParameters: {'slug': slug},
      );

      final data = response.data;

      if (data['success'] == true && data['data'] != null) {
        final page = data['data'];

        title.value = page['title'] ?? '';
        content.value = page['content'] ?? '';
        lastUpdated.value = page['last_updated'] ?? '';
      } else {
        content.value = '';
      }
    } catch (e) {
      debugPrint('RefundPolicyController error: $e');
      content.value = '';
    } finally {
      isLoading.value = false;
    }
  }
}
