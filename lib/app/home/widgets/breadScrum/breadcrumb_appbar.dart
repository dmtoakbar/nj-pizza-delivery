import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';

/// Mapping for route titles
const Map<String, String> routeTitles = {
  Routes.HOME: 'Home',
  Routes.CART: 'Cart',
  Routes.PLACEORDER: 'Place Order',
  Routes.ORDERS: 'Orders',
  Routes.ORDERDETAIL: 'Order Details',
  Routes.PROFILE: 'Profile',
  Routes.CONTACTUS: 'Contact Us',
  Routes.REFUNDPOLICY: 'Refund Policy',
  Routes.REPORT: 'Report',
  Routes.PRIVACY_POLICY: 'Privacy Policy',
  Routes.TERMS: 'Terms And Condition',
  Routes.SHIPPING_POLICY: 'Shipping Policy',
  Routes.CANCELLATION_POLICY: 'Cancellation Policy',
  Routes.ABOUT_US: 'About us',
  Routes.FAQ: 'FAQ',
};

class BreadcrumbAppBar extends StatelessWidget {
  final List<String>? customPaths; // Pass custom breadcrumb
  final bool showBackButton; // Optional back button

  const BreadcrumbAppBar({
    super.key,
    this.customPaths,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    // Determine paths: use custom if provided, otherwise detect from current route
    final List<String> paths =
        customPaths ??
        (() {
          final route = Get.currentRoute;
          final segments = route.split('/').where((e) => e.isNotEmpty).toList();
          final List<String> result = [Routes.HOME];
          String current = '';
          for (final s in segments) {
            current += '/$s';
            if (current != Routes.HOME) result.add(current);
          }
          return result;
        })();

    return SafeArea(
      bottom: false,
      child: Row(
        children: [
          // Optional back button
          if (showBackButton)
            GestureDetector(
              onTap: Get.back,
              behavior: HitTestBehavior.translucent,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  FaIcon(
                    FontAwesomeIcons.angleLeft,
                    size: 17,
                    color: Colors.deepOrange,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Back',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.deepOrange,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),

          if (showBackButton)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                ':',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.deepOrange,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

          // Breadcrumb scroll
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children:
                    paths.map((path) {
                      final bool isLast = path == paths.last;
                      final String title =
                          routeTitles[path] ?? path.replaceAll('/', '');

                      return Row(
                        children: [
                          GestureDetector(
                            onTap:
                                isLast
                                    ? null
                                    : () {
                                      Get.until(
                                        (route) => route.settings.name == path,
                                      );
                                    },
                            child: Text(
                              title,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight:
                                    isLast ? FontWeight.w600 : FontWeight.w400,
                                color:
                                    isLast
                                        ? Colors.black
                                        : Colors.grey.shade600,
                              ),
                            ),
                          ),
                          if (!isLast)
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: FaIcon(
                                FontAwesomeIcons.angleRight,
                                size: 17,
                                color: Colors.deepOrange,
                              ),
                            ),
                        ],
                      );
                    }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
