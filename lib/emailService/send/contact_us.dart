import 'package:nj_pizza_delivery/constants/admin_data.dart';
import 'package:nj_pizza_delivery/emailService/email_service.dart';
import 'package:nj_pizza_delivery/emailService/template/contact_email_template.dart';

Future<bool> sendContactUsToAdmin({
  required String name,
  required String email,
  required String phone,
  required String address,
  required String subject,
  required String query,
}) async {
  final htmlContent = generateContactUsEmail(
    userName: name,
    userEmail: email,
    userPhone: phone,
    userAddress: address,
    userQuery: query,
  );

  final sent = await EmailService.sendEmail(
    toEmail: AdminData.email,
    subject: "New User Query : $subject",
    htmlBody: htmlContent,
    textBody: "",
  );

  if (sent) {
    return true;
  } else {
    return false;
  }
}
