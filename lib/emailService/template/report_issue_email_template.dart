String generateReportIssueEmail({
  required String orderId,
  required String userName,
  required String userEmail,
  required String userPhone,
  required String userAddress,
  required String issueType,
  required String issueMessage,
}) {
  return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Order Issue Report</title>
</head>

<body style="margin:0;padding:0;background-color:#f4f4f4;font-family:Arial,sans-serif;">
  <table width="100%" cellpadding="0" cellspacing="0">
    <tr>
      <td align="center" style="padding:10px;">
        <table width="600" style="background:#ffffff;border-radius:8px;overflow:hidden;box-shadow:0 4px 12px rgba(0,0,0,0.1);">

          <!-- Header -->
          <tr>
            <td style="background:#d84315;padding:20px;color:white;">
              <h2 style="margin:0;">🚨 Order Issue Reported</h2>
              <p style="margin:4px 0 0;font-size:14px;">
                Order ID: <strong>$orderId</strong>
              </p>
            </td>
          </tr>

          <!-- User Details -->
          <tr>
            <td style="padding:20px;">
              <table width="100%" style="border-collapse:collapse;">
                <tr>
                  <td style="padding:8px;font-weight:bold;width:30%;">Customer Name</td>
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

          <!-- Issue Details -->
          <tr>
            <td style="padding:0 20px 20px;">
              <h3 style="color:#d84315;margin-bottom:10px;">⚠️ Issue Details</h3>

              <p>
                <strong>Issue Type:</strong>
                <span style="background:#ffe0b2;padding:6px 10px;border-radius:20px;">
                  $issueType
                </span>
              </p>

              <div style="border:1px solid #ddd;border-radius:6px;padding:15px;background:#fff3e0;line-height:1.6;">
                $issueMessage
              </div>
            </td>
          </tr>

          <!-- Footer -->
          <tr>
            <td style="padding:20px;text-align:center;color:#888;font-size:13px;">
              <p>This issue was reported from the Pizza Hub Delivery app.</p>
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
