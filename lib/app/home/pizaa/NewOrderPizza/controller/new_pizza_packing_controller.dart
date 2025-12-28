import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nj_pizza_delivery/app/home/pizaa/NewOrderPizza/controller/new_pizza_order.dart';
import 'package:nj_pizza_delivery/constants/images_files.dart';

class NewPizzaPackingAnimationController extends GetxController
    with GetSingleTickerProviderStateMixin {

  late Worker _closeBoxWorker;

  late AnimationController controller;

  var boxInitialPosition = -20.0.obs;

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
      duration: const Duration(milliseconds: 700),
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
      if (closed && Get.isRegistered<NewPizzaOrderController>()) {
        Get.find<NewPizzaOrderController>().resetToppings();
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

    await Future.delayed(const Duration(milliseconds: 350));

    // STEP 2: CLOSE BOX
    isCloseBoxShowing.value = true;
    await Future.delayed(const Duration(milliseconds: 100));
    boxImage.value = ImagesFiles.pizzaCloseBox;

    await Future.delayed(const Duration(milliseconds: 250));

    // STEP 3: SCALE + FLY (single forward)
    await controller.forward();

    // CLEANUP
    isVisible.value = false;
    isCloseBoxShowing.value = false;
  }

  @override
  void onClose() {
    _closeBoxWorker.dispose();
    controller.dispose();
    super.onClose();
  }
}
