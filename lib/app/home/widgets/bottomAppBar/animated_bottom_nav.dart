import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nj_pizza_delivery/constants/images_files.dart';
import '../../../../routes/app_routes.dart';
import '../../../../utils/auth_service.dart';

class AnimatedBottomNav extends StatelessWidget {
  const AnimatedBottomNav({super.key});

  int _currentIndex() {
    final route = Get.currentRoute;

    if (route == Routes.HOME) return 0;

    if (route == Routes.MYFAVORITE) return 1;
    if (route == Routes.ORDERS) return 2;
    if (route == Routes.PROFILE) return 3;

    return 0;
  }

  void _onTap(int index) async {
    switch (index) {
      case 0:
        Get.offAllNamed(Routes.HOME);
        break;

      case 1:
        Get.toNamed(Routes.MYFAVORITE);
        break;

      case 2:
        final allowed = await AuthService.checkLoginAndRedirect();
        if (!allowed) return;

        Get.toNamed(Routes.ORDERS);
        break;

      case 3:
        final allowed = await AuthService.checkLoginAndRedirect();
        if (!allowed) return;
        Get.toNamed(Routes.PROFILE);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final current = _currentIndex();

    return SafeArea(
      bottom: true,
      child: Container(
        height: 50,
        padding: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(
              icon: Icons.home,
              selected: current == 0,
              onTap: () => _onTap(0),
            ),
            _NavItem(
              icon: Icons.favorite_border,
              selected: current == 1,
              onTap: () => _onTap(1),
            ),
            _NavItem(
              icon: Icons.receipt_long,
              selected: current == 2,
              onTap: () => _onTap(2),
              useImageIcon: true,
            ),
            _NavItem(
              icon: Icons.person_outline,
              selected: current == 3,
              onTap: () => _onTap(3),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final bool useImageIcon;
  const _NavItem({
    required this.icon,
    required this.selected,
    required this.onTap,
    this.useImageIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          useImageIcon
              ? Image.asset(
                ImagesFiles.taskSquareIcon,
                height: 24,
                color: selected ? Color(0xFFEB5525) : Color(0xFFB7B7B7),
              )
              : Icon(
                icon,
                size: 24,
                color: selected ? Color(0xFFEB5525) : Color(0xFFB7B7B7),
              ),
          const SizedBox(height: 2),
          if (selected)
            Container(
              decoration: BoxDecoration(
                color: Color(0xFFEB5525),
                shape: BoxShape.circle,
              ),
              height: 4,
              width: 4,
            ),
        ],
      ),
    );
  }
}
