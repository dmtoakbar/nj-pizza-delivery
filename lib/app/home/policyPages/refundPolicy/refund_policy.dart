import 'package:flutter/material.dart';
import 'package:nj_pizza_delivery/app/home/policyPages/refundPolicy/controller/refund_policy_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../widgets/headerWithBackButton/header_with_back_button.dart';

class RefundPolicyPage extends GetView<RefundPolicyController> {
  const RefundPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 8),
          CustomHeader(title: 'Refund Policy', showCart: true,),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.content.isEmpty) {
                return const Center(child: Text("No content found"));
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Html(data: controller.content.value)],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
