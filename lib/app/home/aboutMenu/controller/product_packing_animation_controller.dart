import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nj_pizza_delivery/app/home/aboutMenu/controller/pizza_topping_controller.dart';
import 'package:nj_pizza_delivery/constants/images_files.dart';

class ProductPackingAnimationController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late Worker _closeBoxWorker;
  late AnimationController controller;

  var boxInitialPosition = -100.0.obs;

  RxBool isCloseBoxShowing = false.obs;

  late Animation<double> scale;
  late Animation<Offset> position;

  /// Observable box image
  final boxImage = ImagesFiles.pizzaOpenBox.obs;

  /// Whether animation is visible
  final isVisible = false.obs;

  @override
  void onInit() {
    super.onInit();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 630),
    );

    scale = Tween<double>(
      begin: 1.0,
      end: 0.4,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));

    position = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.4, -1.4), // move to top-right
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeIn));

    _closeBoxWorker = ever(isCloseBoxShowing, (bool closed) {
      if (closed && Get.isRegistered<PizzaToppingController>()) {
        Get.find<PizzaToppingController>().resetToppings();
      }
    });
  }

  Future<void> startPackingAnimation() async {
    if (controller.isAnimating) return;

    controller.reset();
    isCloseBoxShowing.value = false;
    isVisible.value = true;

    // STEP 1: OPEN BOX
    boxImage.value = ImagesFiles.pizzaOpenBox;

    await Future.delayed(const Duration(milliseconds: 315));

    // STEP 2: CLOSE BOX
    isCloseBoxShowing.value = true;
    await Future.delayed(const Duration(milliseconds: 90));
    boxImage.value = ImagesFiles.pizzaCloseBox;

    await Future.delayed(const Duration(milliseconds: 225));

    // STEP 3: SCALE + FLY (single forward)
    await controller.forward();

    // CLEANUP
    isVisible.value = false;
    isCloseBoxShowing.value = false;
  }

  @override
  void onClose() {
    controller.dispose();
    _closeBoxWorker.dispose();
    super.onClose();
  }
}
