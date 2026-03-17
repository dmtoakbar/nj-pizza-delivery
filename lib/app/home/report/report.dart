import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nj_pizza_delivery/app/auth/widgets/app_text_field.dart';
import '../widgets/headerWithBackButton/header_with_back_button.dart';
import 'controller/report_controller.dart';

class ReportScreen extends GetView<ReportController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 8),
            CustomHeader(title: 'Report', showCart: true),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 10,
                ),
                child: Obx(
                  () => Column(
                    children: [
                      SizedBox(height: 10),
                      // Top Icon
                      Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.orange.shade100,
                        ),
                        child: const Icon(
                          Icons.report_problem_outlined,
                          size: 70,
                          color: Colors.deepOrange,
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        "Report an Issue",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                        ),
                      ),

                      const SizedBox(height: 35),

                      // SUBJECT
                      AppTextField(
                        controller: controller.subjectController,
                        hintText: "Report Subject",
                      ),
                      const SizedBox(height: 20),

                      // ORDER ID (Optional)
                      AppTextField(
                        controller: controller.orderIdController,
                        hintText: "Order ID",
                      ),
                      const SizedBox(height: 20),

                      // MESSAGE
                      AppTextField(
                        controller: controller.messageController,
                        hintText: "Describe your issue",
                        maxLines: 5,
                      ),
                      const SizedBox(height: 30),

                      // SUBMIT BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed:
                              controller.isSending.value
                                  ? null
                                  : controller.submitReport,
                          child:
                              controller.isSending.value
                                  ? Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                  : const Text(
                                    "Submit Report",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
