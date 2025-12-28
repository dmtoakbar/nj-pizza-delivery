import 'package:nj_pizza_delivery/constants/admin_data.dart';
import 'package:nj_pizza_delivery/emailService/email_service.dart';
import 'package:nj_pizza_delivery/emailService/template/report_issue_email_template.dart';

Future<bool> sendOrderIssueToAdmin({
  required String orderId,
  required String name,
  required String email,
  required String phone,
  required String address,
  required String issue,
  required issueMessage,
}) async {
  final htmlContent = generateReportIssueEmail(
    orderId: orderId,
    userName: name,
    userEmail: email,
    userPhone: phone,
    userAddress: address,
    issueType: issue,
    issueMessage: issueMessage,
  );

  final sent = await EmailService.sendEmail(
    toEmail: AdminData.email,
    subject: "🚨 Order Issue Reported $orderId",
    htmlBody: htmlContent,
    textBody: "",
  );

  if (sent) {
    return true;
  } else {
    return false;
  }
}
