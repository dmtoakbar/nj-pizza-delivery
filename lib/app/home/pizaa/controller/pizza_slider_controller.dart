import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nj_pizza_delivery/app/home/pizaa/data/pizza_data.dart';
import 'package:nj_pizza_delivery/app/home/pizaa/model/pizza_slide_model.dart';

class PizzaSliderController extends GetxController
    with GetTickerProviderStateMixin {

  late AnimationController controller;
  late AnimationController outGoingController;
  late AnimationController rowOpacityController;

  late Animation<Offset> slideAnimation;
  late Animation<Offset> outGoingSlider;
  late Animation<double> rowOpacity;

  final RxInt currentPizza = 0.obs;
  final RxInt previousPizza = 0.obs;
  final RxBool outGoing = false.obs;

  final RxList<PizzaSlideModel> pizzaList = PizzaData.pizzas.obs;

  final RxDouble plateRotation = 0.0.obs;

  PizzaSlideModel get currentPizzaModel =>
      pizzaList[currentPizza.value];

  PizzaSlideModel get previousPizzaModel =>
      pizzaList[previousPizza.value];

  @override
  void onInit() {
    super.onInit();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    outGoingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    rowOpacityController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    slideAnimation = const AlwaysStoppedAnimation(Offset.zero);
    outGoingSlider = const AlwaysStoppedAnimation(Offset.zero);

    rowOpacity = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: rowOpacityController, curve: Curves.easeOut),
    );

    // ✅ Reset outgoing state automatically
    outGoingController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        outGoing.value = false;
      }
    });
  }

  // ------------------------------
  // SLIDE FROM LEFT
  // ------------------------------
  void slideInFromLeft() {
    _startTransition(isLeft: true);
  }

  // ------------------------------
  // SLIDE FROM RIGHT
  // ------------------------------
  void slideInFromRight() {
    _startTransition(isLeft: false);
  }

  void _startTransition({required bool isLeft}) {
    rowOpacityController.forward();

    previousPizza.value = currentPizza.value;
    outGoing.value = true;

    // outgoing
    outGoingSlider = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(isLeft ? 1.6 : -1.6, 1.2),
    ).animate(
      CurvedAnimation(parent: outGoingController, curve: Curves.easeOut),
    );

    outGoingController
      ..reset()
      ..forward();

    // incoming
    slideAnimation = Tween<Offset>(
      begin: Offset(isLeft ? -1.2 : 1.2, 0.8),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeOutCubic),
    );

    currentPizza.value =
        (currentPizza.value + 1) % pizzaList.length;

    controller
      ..reset()
      ..forward();

    plateRotation.value += isLeft ? -0.20 : 0.20;

    Future.delayed(const Duration(milliseconds: 350), () {
      rowOpacityController.reverse();
    });
  }

  @override
  void onClose() {
    controller.dispose();
    outGoingController.dispose();
    rowOpacityController.dispose();
    super.onClose();
  }
}

