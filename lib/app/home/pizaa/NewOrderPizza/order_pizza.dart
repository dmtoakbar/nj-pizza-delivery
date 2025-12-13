import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nj_pizza_delivery/app/home/cart/controller/cart_controller.dart';
import 'package:nj_pizza_delivery/app/home/cart/model/cart_item.dart';
import 'package:nj_pizza_delivery/app/home/pizaa/NewOrderPizza/controller/new_pizza_order.dart';
import 'package:nj_pizza_delivery/app/home/pizaa/controller/pizza_packing_controller.dart';
import 'package:nj_pizza_delivery/app/home/pizaa/widget/pizza_packing_widget.dart';
import 'package:nj_pizza_delivery/app/home/widgets/appBar/app_bar_widget.dart';

class NewOrderPizza extends GetView<NewPizzaOrderController> {
  NewOrderPizza({super.key});

  final pizzaPacking = Get.put(
    PizzaPackingAnimationController(extraAddOnePage: true),
    permanent: false,
  );

  final cart = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    const double pizzaSize = 260;
    const double pizzaTop = 40;

    final components = appBarBundle();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: components.appBar,
      drawer: components.drawer,

      body: LayoutBuilder(
        builder: (context, constraints) {
          final centerX = constraints.maxWidth / 2;

          controller.setPizzaSpecs(
            Offset(centerX, pizzaTop + pizzaSize / 2),
            pizzaSize / 2,
          );

          return Stack(
            children: [
              PizzaPackingAnimationWidget(),

              /// 🍕 PIZZA
              Obx(() {
                if (pizzaPacking.isCloseBoxShowing.value) {
                  return const SizedBox.shrink();
                }

                return Positioned(
                  top: pizzaTop,
                  left: centerX - pizzaSize / 2,
                  child: Container(
                    width: pizzaSize,
                    height: pizzaSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(controller.pizza.image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              }),

              /// 🧀 TOPPINGS
              Obx(() {
                return Stack(
                  children:
                      controller.toppings.map((item) {
                        return TweenAnimationBuilder<Offset>(
                          tween: Tween(begin: item["start"], end: item["end"]),
                          duration: const Duration(milliseconds: 700),
                          curve: Curves.easeOutBack,
                          builder: (_, value, __) {
                            return Positioned(
                              left: controller.pizzaCenter.dx + value.dx - 18,
                              top: controller.pizzaCenter.dy + value.dy - 18,
                              child: Image.asset(item["img"], width: 35),
                            );
                          },
                        );
                      }).toList(),
                );
              }),

              /// 💰 INFO + INGREDIENTS
              Positioned(
                bottom: 110,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '<',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          controller.pizza.name.substring(0, 1),
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '>',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '\$${controller.pizza.price}',
                      style: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'PlayfairDisplay',
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      controller.pizza.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),

                    /// 🌶️ INGREDIENT SCROLL
                    SizedBox(
                      height: 70,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        physics: const BouncingScrollPhysics(),
                        itemCount: controller.allIngredients.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 20),
                        itemBuilder: (_, index) {
                          return ingredientDraggable(
                            controller.allIngredients[index],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),

      /// 🛒 CART
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 18),
        child: Container(
          width: 65,
          height: 65,
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(16),
          ),
          child: IconButton(
            icon: const Icon(
              Icons.shopping_cart,
              size: 32,
              color: Colors.white,
            ),
            onPressed: () async {
              await pizzaPacking.startPackingAnimation();
              cart.addItem(
                CartItem(
                  name: controller.pizza.name,
                  image: controller.pizza.image,
                  price: controller.pizza.price,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  /// 🍅 INGREDIENT DRAG
  Widget ingredientDraggable(String img) {
    return Draggable(
      data: img,
      feedback: Image.asset(img, width: 50),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: Image.asset(img, width: 50),
      ),
      child: Image.asset(img, width: 50),
      onDragEnd: (details) {
        final pos = details.offset + const Offset(25, 25);
        if (controller.isInsidePizza(pos)) {
          controller.addBurstToppings(img);
        }
      },
    );
  }
}
