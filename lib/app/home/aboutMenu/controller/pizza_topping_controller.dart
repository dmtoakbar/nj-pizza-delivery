import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../api/api_path.dart';
import '../../../../api/config.dart';
import '../../cart/model/cart_item.dart';
import '../model/extra_topping_model.dart';

class PizzaToppingController extends GetxController {
  var toppingLayer = 1;
  double toppingSideWideRadius = 0.0;

  final isLoading = false.obs;

  /// Ingredient images
  final allIngredients = <ToppingExtra>[].obs;

  final RxList<ExtraItem> selectedExtras = <ExtraItem>[].obs;

  final ScrollController scrollController = ScrollController();
  final selectedIndex = 2.obs;

  /// { img, start, end }
  final toppings = <Map<String, dynamic>>[].obs;

  Offset pizzaCenter = Offset.zero;
  double pizzaRadius = 0;

  @override
  void onInit() {
    super.onInit();
    _loadToppings();

    scrollController.addListener(_handleScroll);
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void _handleScroll() {
    if (!scrollController.hasClients) return;

    final width = Get.context!.width;
    final itemWidth = width / 5;
    final center = width / 2;
    final offset = scrollController.offset;

    int index = ((offset + center - itemWidth / 2) / itemWidth).round();

    if (index >= 0 && index < allIngredients.length) {
      selectedIndex.value = index;
    }
  }

  void selectIndex(int index) {
    if (index >= 0 && index < allIngredients.length) {
      selectedIndex.value = index;
    }
  }

  Future<void> _loadToppings() async {
    try {
      isLoading.value = true;
      final toppings = await _fetchToppings();
      allIngredients.clear();
      allIngredients.addAll(toppings);
    } catch (e) {
      debugPrint('❌ Failed to load toppings: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<ToppingExtra>> _fetchToppings() async {
    final response = await Config.dio.get('/${ApiPath.extraToppings}');

    final Map<String, dynamic> json =
        response.data is String
            ? jsonDecode(response.data)
            : Map<String, dynamic>.from(response.data);

    final List list = json['data'] ?? [];

    return list.map((e) => ToppingExtra.fromJson(e)).toList();
  }

  bool isInsidePizza(Offset position) {
    return (position - pizzaCenter).distance <= pizzaRadius + 100;
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
    // add extra
    final topping = allIngredients.firstWhere(
      (element) => element.image == img,
    );

    final index = selectedExtras.indexWhere((e) => e.name == topping.name);

    if (index == -1) {
      // ➕ Add new extra
      selectedExtras.add(
        ExtraItem(name: topping.name, price: topping.price, quantity: 1),
      );
    } else {
      // 🔄 Update quantity
      final existing = selectedExtras[index];

      selectedExtras[index] = ExtraItem(
        name: existing.name,
        price: existing.price,
        quantity: existing.quantity + 1,
      );
    }

    // end adding extra
    final batchId = DateTime.now().microsecondsSinceEpoch;

    int pieces = toppingLayer <= 3 ? 6 : 3;
    for (int i = 0; i < pieces; i++) {
      await Future.delayed(const Duration(milliseconds: 72));
      toppings.add({
        "img": img,
        "start": randomStartFromScreen(index: i, total: pieces),
        "end": randomPositionInside(
          index: i,
          total: pieces,
          layer: toppingLayer,
        ),
        'bachId': batchId,
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

  void decreaseExtra(ExtraItem extra) {
    final index = selectedExtras.indexWhere((e) => e.name == extra.name);
    if (index == -1) return;

    final old = selectedExtras[index];

    final topping = allIngredients.firstWhereOrNull(
      (element) => element.name == extra.name,
    );

    if (old.quantity > 1) {
      // ➖ Update quantity
      selectedExtras[index] = ExtraItem(
        name: old.name,
        price: old.price,
        quantity: old.quantity - 1,
      );

      // 🔥 REMOVE LAST BATCH (correct way)
      if (topping != null) {
        final lastBatch =
            toppings.where((t) => t["img"] == topping.image).toList();

        if (lastBatch.isNotEmpty) {
          final last = lastBatch.last; // ✅ latest added

          toppings.removeWhere(
            (t) => t["img"] == topping.image && t["bachId"] == last["bachId"],
          );
        }
      }
    } else {
      deleteExtra(extra);
    }

    // Reset
    if (toppings.isEmpty) {
      toppingLayer = 1;
      toppingSideWideRadius = 0.0;
    }
  }

  void deleteExtra(ExtraItem extra) {
    selectedExtras.removeWhere((e) => e.name == extra.name);

    // 2️⃣ Find related topping image
    final topping = allIngredients.firstWhereOrNull(
      (element) => element.name == extra.name,
    );

    if (topping != null) {
      // 3️⃣ Remove all visual pieces from pizza
      toppings.removeWhere((t) => t["img"] == topping.image);
    }

    // 4️⃣ Optional: reset layer logic if no toppings left
    if (toppings.isEmpty) {
      toppingLayer = 1;
      toppingSideWideRadius = 0.0;
    }
  }
}
