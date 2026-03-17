import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nj_pizza_delivery/app/home/aboutMenu/controller/product_packing_animation_controller.dart';

class ProductPackingAnimation extends StatelessWidget {
  final ProductPackingAnimationController controller =
  Get.find<ProductPackingAnimationController>();

  ProductPackingAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.isVisible.value) return const SizedBox.shrink();

      return Positioned(
        top: controller.boxInitialPosition,
        child: Align(
          alignment: Alignment.center,
          child: SlideTransition(
            position: controller.position,
            child: ScaleTransition(
              scale: controller.scale,
              child: Image.asset(controller.boxImage.value, width: 380),
            ),
          ),
        ),
      );
    });
  }
}
