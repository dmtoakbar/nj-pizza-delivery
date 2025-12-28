String generateContactUsEmail({
  required String userName,
  required String userEmail,
  required String userPhone,
  required String userAddress,
  required String userQuery,
}) {
  return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Contact Us Message</title>
</head>

<body style="margin:0;padding:0;background-color:#f4f4f4;font-family:Arial,sans-serif;">
  <table width="100%" cellpadding="0" cellspacing="0">
    <tr>
      <td align="center" style="padding:10px;">
        <table width="600" style="background:#ffffff;border-radius:8px;overflow:hidden;box-shadow:0 4px 12px rgba(0,0,0,0.1);">

          <!-- Header -->
          <tr>
            <td style="background:#e65100;padding:20px;color:white;">
              <h2 style="margin:0;">📩 New Contact Us Message</h2>
              <p style="margin:4px 0 0;font-size:14px;">User has sent a query</p>
            </td>
          </tr>

          <!-- User Details -->
          <tr>
            <td style="padding:20px;">
              <table width="100%" style="border-collapse:collapse;">
                <tr>
                  <td style="padding:8px;font-weight:bold;width:30%;">Name</td>
                  <td style="padding:8px;">$userName</td>
                </tr>
                <tr style="background:#fafafa;">
                  <td style="padding:8px;font-weight:bold;">Email</td>
                  <td style="padding:8px;">$userEmail</td>
                </tr>
                <tr>
                  <td style="padding:8px;font-weight:bold;">Phone</td>
                  <td style="padding:8px;">$userPhone</td>
                </tr>
                <tr style="background:#fafafa;">
                  <td style="padding:8px;font-weight:bold;">Address</td>
                  <td style="padding:8px;">$userAddress</td>
                </tr>
              </table>
            </td>
          </tr>

          <!-- Query Box -->
          <tr>
            <td style="padding:0 20px 20px;">
              <h3 style="color:#e65100;margin-bottom:10px;">📝 User Query</h3>
              <div style="border:1px solid #ddd;border-radius:6px;padding:15px;background:#fff8f5;line-height:1.6;">
                $userQuery
              </div>
            </td>
          </tr>

          <!-- Footer -->
          <tr>
            <td style="padding:20px;text-align:center;color:#888;font-size:13px;">
              <p>This message was sent from the Pizza Hub Delivery app.</p>
              <p>© ${DateTime.now().year} Pizza Hub Delivery</p>
            </td>
          </tr>

        </table>
      </td>
    </tr>
  </table>
</body>
</html>
''';
}
