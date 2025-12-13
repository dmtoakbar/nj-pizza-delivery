import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nj_pizza_delivery/app/home/widgets/appBar/app_bar_widget.dart';
import 'controller/report_controller.dart';

class ReportScreen extends GetView<ReportController> {
  @override
  Widget build(BuildContext context) {
    final components = appBarBundle();

    return Scaffold(
      appBar: components.appBar,
      drawer: components.drawer,
      backgroundColor: const Color(0xFFFDFAF5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
          child: Column(
            children: [
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
              TextField(
                controller: controller.subjectController,
                style: GoogleFonts.poppins(),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.title_outlined),
                  labelText: "Report Subject",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ORDER ID (Optional)
              TextField(
                controller: controller.orderIdController,
                keyboardType: TextInputType.number,
                style: GoogleFonts.poppins(),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.receipt_long_outlined),
                  labelText: "Order ID (optional)",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // MESSAGE
              TextField(
                controller: controller.messageController,
                maxLines: 5,
                style: GoogleFonts.poppins(),
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  labelText: "Describe your issue",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
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
                  onPressed: controller.submitReport,
                  child: const Text(
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
    );
  }
}
