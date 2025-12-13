import 'package:flutter/material.dart';
import 'package:nj_pizza_delivery/app/home/widgets/appBar/app_bar_widget.dart';

class RefundPolicyPage extends StatelessWidget {
  const RefundPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final components = appBarBundle();
    return Scaffold(
      appBar: components.appBar,
      drawer: components.drawer,
      backgroundColor: const Color(0xFFFDFAF5),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Last Updated
            Text(
              "Last Updated: January 2025",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 20),

            /// Heading
            const Text(
              "Refund Policy",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),

            const Text(
              "At Your Company Name, we strive to provide high-quality products and "
                  "excellent customer service. If you are not fully satisfied with "
                  "your purchase, our refund policy explains your options.",
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 20),

            _sectionTitle("1. Eligibility for Refunds"),
            _sectionBody(
              "• Item received is damaged, defective, or incorrect.\n"
                  "• Service provided does not meet the expected or described quality.\n"
                  "• Product fails to perform due to an issue from our side.\n"
                  "• Refund requests must be submitted within X days of purchase.",
            ),

            _sectionTitle("2. Non-Refundable Items"),
            _sectionBody(
              "• Digital products already downloaded or used.\n"
                  "• Items damaged by improper customer handling.\n"
                  "• Customized or personalized products.\n"
                  "• Clearance or promotional items.\n"
                  "• Any request made after the refund window has expired.",
            ),

            _sectionTitle("3. Refund Process"),
            _sectionBody(
              "1. Contact our support team at support@example.com.\n"
                  "2. Provide your order ID, name, and issue details.\n"
                  "3. Attach photos/videos for damaged or incorrect items.\n\n"
                  "Refunds are processed within 5–7 business days after approval.",
            ),

            _sectionTitle("4. Order Cancellation"),
            _sectionBody(
              "• You may cancel your order before it is processed or shipped.\n"
                  "• Orders already in transit cannot be canceled.\n"
                  "• Digital service bookings can be canceled X hours before the schedule.",
            ),

            _sectionTitle("5. Late or Missing Refunds"),
            _sectionBody(
              "If your refund has not been received:\n"
                  "• Recheck your bank or payment account.\n"
                  "• Contact your bank as processing times vary.\n"
                  "• For unresolved issues, contact us for support.",
            ),

            _sectionTitle("6. Exchange Policy"),
            _sectionBody(
              "We offer exchanges only for defective or damaged products. "
                  "Please contact us with required details and proof.",
            ),

            _sectionTitle("7. Contact Us"),
            _sectionBody(
              "Email: support@example.com\n"
                  "Phone: +91 XXXXX XXXXX\n"
                  "Website: www.example.com",
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  /// Section Title Widget
  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Section Body Widget
  Widget _sectionBody(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        height: 1.5,
        color: Colors.black87,
      ),
    );
  }
}
