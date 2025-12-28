String generateOrderEmail({
  required String customerName,
  required String customerEmail,
  required String customerPhone,
  required String customerAddress,
  required List<Map<String, dynamic>> items,
}) {
  double totalPrice = 0;

  for (var item in items) {
    totalPrice += item['quantity'] * item['price'];
  }

  final orderRows = items.map((item) {
    final itemTotal = item['quantity'] * item['price'];
    return '''
      <tr>
        <td style="padding:10px;border:1px solid #ddd;">${item['name']}</td>
        <td style="padding:10px;border:1px solid #ddd;text-align:center;">${item['quantity']}</td>
        <td style="padding:10px;border:1px solid #ddd;text-align:right;">\$${item['price'].toStringAsFixed(2)}</td>
        <td style="padding:10px;border:1px solid #ddd;text-align:right;">\$${itemTotal.toStringAsFixed(2)}</td>
      </tr>
    ''';
  }).join();

  return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>New Order</title>
</head>
<body style="margin:0;padding:0;background:#f4f4f4;font-family:Arial,sans-serif;">
  <table width="100%" cellpadding="0" cellspacing="0">
    <tr>
      <td align="center" style="padding:10px;">
        <table width="600" style="background:#ffffff;border-radius:8px;overflow:hidden;">
          
          <!-- Header -->
          <tr>
            <td style="background:#e65100;padding:20px;color:white;">
              <h2 style="margin:0;">🍕 New Order Received</h2>
            </td>
          </tr>

          <!-- Customer Info -->
          <tr>
            <td style="padding:20px;">
              <p><strong>Name:</strong> $customerName</p>
              <p><strong>Email:</strong> $customerEmail</p>
              <p><strong>Phone:</strong> $customerPhone</p>
              <p><strong>Address:</strong> $customerAddress</p>
            </td>
          </tr>

          <!-- Order Table -->
          <tr>
            <td style="padding:0 20px 20px;">
              <table width="100%" style="border-collapse:collapse;">
                <thead>
                  <tr style="background:#ffccbc;">
                    <th style="padding:10px;border:1px solid #ddd;">Item</th>
                    <th style="padding:10px;border:1px solid #ddd;">Qty</th>
                    <th style="padding:10px;border:1px solid #ddd;">Price</th>
                    <th style="padding:10px;border:1px solid #ddd;">Total</th>
                  </tr>
                </thead>
                <tbody>
                  $orderRows
                  <tr style="font-weight:bold;background:#ffe0b2;">
                    <td colspan="3" style="padding:10px;border:1px solid #ddd;text-align:right;">
                      Grand Total
                    </td>
                    <td style="padding:10px;border:1px solid #ddd;text-align:right;">
                      \$${totalPrice.toStringAsFixed(2)}
                    </td>
                  </tr>
                </tbody>
              </table>
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
