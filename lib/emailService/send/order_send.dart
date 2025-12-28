import 'package:nj_pizza_delivery/constants/admin_data.dart';
import 'package:nj_pizza_delivery/emailService/email_service.dart';
import 'package:nj_pizza_delivery/emailService/template/order_template.dart';

Future<bool> sendOrderToAdmin({
  required String name,
  required String email,
  required String phone,
  required String address,
  required List<Map<String, dynamic>> orderItems,
}) async {
  final htmlContent = generateOrderEmail(
    customerName: name,
    customerEmail: email,
    customerPhone: phone,
    customerAddress: address,
    items: orderItems,
  );

  final sent = await EmailService.sendEmail(
    toEmail: AdminData.email,
    subject: "🍕 New Order Received from $name",
    htmlBody: htmlContent,
    textBody: "",
  );

  if (sent) {
    return true;
  } else {
    return false;
  }
}
