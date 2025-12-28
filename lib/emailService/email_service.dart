import 'dart:io';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EmailService {
  static final String smtpHost = 'smtp.gmail.com';
  static final int smtpPort = 587;
  static final String username = 'dmtoakbar@gmail.com';
  static final String password = 'ncikntazgzrbnjix';

  /// Send an email
  static Future<bool> sendEmail({
    required String toEmail,
    required String subject,
    String? textBody,
    String? htmlBody,
    List<String>? attachments,
  }) async {
    try {
      final smtpServer = SmtpServer(
        smtpHost,
        port: smtpPort,
        username: username,
        password: password,
      );

      final message =
          Message()
            ..from = Address(username, 'Pizza Hub')
            ..recipients.add(toEmail)
            ..subject = subject
            ..text = textBody ?? 'This is a fallback text'
            ..html = htmlBody ?? textBody ?? '';

      // Attach files if provided
      if (attachments != null && attachments.isNotEmpty) {
        for (var filePath in attachments) {
          message.attachments.add(FileAttachment(File(filePath)));
        }
      }

      final sendReport = await send(message, smtpServer);

      print('Email sent: $sendReport');
      return true;
    } on MailerException catch (e) {
      print('Email not sent. \n${e.toString()}');
      return false;
    } catch (e) {
      print('Unexpected error: $e');
      return false;
    }
  }
}
