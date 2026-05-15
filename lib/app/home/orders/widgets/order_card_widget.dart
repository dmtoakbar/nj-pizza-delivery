import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class OrderCard extends StatelessWidget {
  final String orderId;
  final DateTime createdAt;
  final double totalAmount;
  final String status;
  final String paymentStatus;
  final VoidCallback onTap;

  const OrderCard({
    super.key,
    required this.orderId,
    required this.createdAt,
    required this.totalAmount,
    required this.status,
    required this.paymentStatus,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final paymentColor =
        paymentStatus.toLowerCase() == 'Paid'
            ? const Color(0xFF22C55E)
            : const Color(0xFFFF3B30);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          /// TOP SECTION
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1EB),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.receipt_long_rounded,
                  color: Color(0xFFEB5525),
                  size: 28,
                ),
              ),

              const SizedBox(width: 4),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Order #${orderId.substring(0, 8)}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Row(
                      children: [
                        Icon(
                          Icons.calendar_month_outlined,
                          size: 14,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 2),

                        Text(
                          DateFormat('dd MMM yyyy').format(createdAt),
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),

                        const SizedBox(width: 5),

                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.grey.shade500,
                        ),

                        const SizedBox(width: 2),

                        Text(
                          DateFormat('hh:mm a').format(createdAt),
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "\$${totalAmount.toStringAsFixed(2)}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF1EB),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.receipt_long_outlined,
                          size: 16,
                          color: Color(0xFFEB5525),
                        ),

                        const SizedBox(width: 6),

                        Text(
                          "View Bill",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFEB5525),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          Divider(color: Colors.grey.shade200),

          const SizedBox(height: 12),

          /// TRACKING
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBF8),
              borderRadius: BorderRadius.circular(22),
            ),
            child: _trackingSection(),
          ),

          const SizedBox(height: 12),

          /// STATUS + PAYMENT
          Row(
            children: [
              Expanded(
                child: _statusBox(
                  title: "Status",
                  value: status.replaceAll("_", " "),
                  color: _getStatusColor(status),
                  icon: Icons.access_time_rounded,
                ),
              ),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 18),
                width: 1,
                height: 46,
                color: Colors.grey.shade200,
              ),

              Expanded(
                child: _statusBox(
                  title: "Payment",
                  value: paymentStatus,
                  color: paymentColor,
                  icon: Icons.credit_card_rounded,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// BUTTON
          SizedBox(
            width: double.infinity,
            height: 58,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                padding: EdgeInsets.zero,
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF7A2F), Color(0xFFEB5525)],
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 10),
                      const Icon(
                        Icons.receipt_long_outlined,
                        color: Colors.white,
                      ),

                      const SizedBox(width: 5),

                      Text(
                        "View Details",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),

                      const Spacer(),

                      const Padding(
                        padding: EdgeInsets.only(right: 18),
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ================= TRACKING =================

  Widget _trackingSection() {
    final steps = [
      {
        "key": "pending",
        "title": "Order\nPlaced",
        "icon": Icons.receipt_long_rounded,
      },
      {
        "key": "accepted",
        "title": "Confirmed",
        "icon": Icons.restaurant_rounded,
      },
      {
        "key": "out_for_delivery",
        "title": "On The\nWay",
        "icon": Icons.delivery_dining,
      },
      {
        "key": "delivered",
        "title": "Delivered",
        "icon": Icons.inventory_2_rounded,
      },
    ];

    final currentStep = _getCurrentStep(status);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(steps.length, (index) {
        final isCompleted = index <= currentStep;
        final isLast = index == steps.length - 1;

        return Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// ICON
                    SizedBox(
                      height: 58,
                      child: Center(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient:
                                isCompleted
                                    ? const LinearGradient(
                                      colors: [
                                        Color(0xFFFF7A2F),
                                        Color(0xFFEB5525),
                                      ],
                                    )
                                    : null,
                            color: isCompleted ? null : Colors.white,
                            border: Border.all(
                              color:
                                  isCompleted
                                      ? Colors.transparent
                                      : Colors.grey.shade300,
                            ),
                          ),
                          child: Icon(
                            steps[index]["icon"] as IconData,
                            color: isCompleted ? Colors.white : Colors.grey,
                            size: 24,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// TITLE FIXED HEIGHT
                    SizedBox(
                      height: 42,
                      child: Text(
                        steps[index]["title"] as String,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                          color:
                              isCompleted
                                  ? const Color(0xFFEB5525)
                                  : Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// LINE
              if (!isLast)
                Padding(
                  padding: const EdgeInsets.only(top: 26),
                  child: Container(
                    width: 34,
                    height: 3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color:
                          index < currentStep
                              ? const Color(0xFFEB5525)
                              : Colors.grey.shade300,
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  int _getCurrentStep(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 0;

      case 'accepted':
      case 'preparing':
      case 'ready':
        return 1;

      case 'out_for_delivery':
        return 2;

      case 'delivered':
        return 3;

      default:
        return 0;
    }
  }

  Widget _statusBox({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey.shade600),
        ),

        const SizedBox(height: 10),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.10),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 18),

              const SizedBox(width: 8),

              Flexible(
                child: Text(
                  value.toUpperCase(),
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: color,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return const Color(0xFFFF9800);

      case 'accepted':
      case 'preparing':
      case 'ready':
        return const Color(0xFF3B82F6);

      case 'out_for_delivery':
        return const Color(0xFF14B8A6);

      case 'delivered':
        return const Color(0xFF22C55E);

      case 'cancelled':
        return const Color(0xFFEF4444);

      default:
        return Colors.grey;
    }
  }
}
