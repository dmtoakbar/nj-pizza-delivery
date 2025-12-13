import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nj_pizza_delivery/app/home/pizaa/NewOrderPizza/controller/new_pizza_order.dart';
import 'package:nj_pizza_delivery/constants/images_files.dart';

class PizzaPackingAnimationController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final bool extraAddOnePage;
  PizzaPackingAnimationController({this.extraAddOnePage = false});

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


    if(extraAddOnePage) {
      ever(isCloseBoxShowing, (value) {
        if (value == true) {
          Get.find<NewPizzaOrderController>().resetToppings();
        }
      });
    }

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    scale = Tween<double>(
      begin: 1.0,
      end: 0.4,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));

    position = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.4, -1.4), // move to top-right
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeIn));
  }

  Future<void> startPackingAnimation() async {
    if (controller.isAnimating) return;

    controller.reset();
    isCloseBoxShowing.value = false;
    isVisible.value = true;

    // STEP 1: OPEN BOX
    boxImage.value = ImagesFiles.pizzaOpenBox;

    await Future.delayed(const Duration(seconds: 1));

    // STEP 2: CLOSE BOX
    isCloseBoxShowing.value = true;
    boxImage.value = ImagesFiles.pizzaCloseBox;

    await Future.delayed(const Duration(milliseconds: 500));

    // STEP 3: SCALE + FLY (single forward)
    await controller.forward();

    // CLEANUP
    isVisible.value = false;
    isCloseBoxShowing.value = false;
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }
}
