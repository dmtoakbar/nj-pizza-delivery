import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nj_pizza_delivery/app/home/pizaa/data/pizza_data.dart';
import 'package:nj_pizza_delivery/app/home/pizaa/model/pizza_slide_model.dart';
import 'package:nj_pizza_delivery/constants/images_files.dart';

class NewPizzaOrderController extends GetxController {
  late int pizzaId;
  late PizzaSlideModel pizza;
  var toppingLayer = 1;
  double toppingSideWideRadius = 0.0;

  /// Ingredient images
  final allIngredients =
      <String>[
        ImagesFiles.topping1,
        ImagesFiles.topping2,
        ImagesFiles.topping3,
        ImagesFiles.topping4,
        ImagesFiles.topping5,
        ImagesFiles.topping6,
        ImagesFiles.topping7,
      ].obs;

  /// { img, start, end }
  final toppings = <Map<String, dynamic>>[].obs;

  Offset pizzaCenter = Offset.zero;
  double pizzaRadius = 0;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments as Map<String, dynamic>;
    pizzaId = args['pizzaId'];

    pizza = PizzaData.pizzas.firstWhere(
      (p) => p.id == pizzaId,
      orElse: () => PizzaData.pizzas.first,
    );
  }

  bool isInsidePizza(Offset position) {
    return (position - pizzaCenter).distance <= pizzaRadius;
  }

  void setPizzaSpecs(Offset center, double radius) {
    pizzaCenter = center;
    pizzaRadius = radius;
  }

  Offset randomPositionInside({
    required int index,
    required int total,
    required int layer,
  }) {
    final double maxRadius = pizzaRadius * 0.75;
    final double layerGap = 22;
    final double radius = maxRadius - (layer * layerGap);

    final double baseAngle = (2 * pi / total) * index;

    final double angle = baseAngle + toppingSideWideRadius;

    return Offset(cos(angle) * radius, sin(angle) * radius);
  }

  Offset randomStartFromScreen({required int index, required int total}) {
    final angle = (2 * pi / 6) * index;
    return Offset(cos(angle) * 260, sin(angle) * 260);
  }

  Future<void> addBurstToppings(String img) async {
    int pieces = toppingLayer <= 3 ? 6 : 3;
    for (int i = 0; i < pieces; i++) {
      await Future.delayed(const Duration(milliseconds: 80));
      toppings.add({
        "img": img,
        "start": randomStartFromScreen(index: i, total: pieces),
        "end": randomPositionInside(
          index: i,
          total: pieces,
          layer: toppingLayer,
        ),
      });
    }

    if (toppingLayer >= 4) {
      toppingLayer = 0;
      toppingSideWideRadius = toppingSideWideRadius + 10;
    } else {
      toppingLayer++;
    }
  }

  void resetToppings() {
    toppings.clear();
    toppingLayer = 1;
    toppingSideWideRadius = 0.0;
  }
}
