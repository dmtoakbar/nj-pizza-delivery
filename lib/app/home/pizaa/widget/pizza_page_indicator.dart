import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nj_pizza_delivery/app/home/pizaa/controller/pizza_slider_controller.dart';

class PizzaPageIndicator extends StatelessWidget {
  const PizzaPageIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<PizzaSliderController>();

    return Obx(() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          ctrl.pizzaList.length,
              (index) {
            bool isActive = index == ctrl.currentPizza.value;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: isActive ? 10 : 8,
              height: isActive ? 10 : 8,
              decoration: BoxDecoration(
                color: isActive ? Colors.black : Colors.grey,
                shape: BoxShape.circle,
              ),
            );
          },
        ),
      );
    });
  }
}
