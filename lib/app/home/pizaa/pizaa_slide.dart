import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nj_pizza_delivery/app/home/pizaa/controller/pizza_packing_controller.dart';
import 'package:nj_pizza_delivery/app/home/pizaa/controller/pizza_slider_controller.dart';
import 'package:nj_pizza_delivery/app/home/pizaa/widget/pizza_slide_widget.dart';
import 'package:nj_pizza_delivery/app/home/widgets/appBar/app_bar_widget.dart';
import 'package:nj_pizza_delivery/constants/images_files.dart';
import 'package:nj_pizza_delivery/app/home/pizaa/widget/pizza_page_indicator.dart';

class PizzaSliderView extends GetView<PizzaSliderController> {
  PizzaSliderView({super.key});

  final pizzaPacking = Get.put(
    PizzaPackingAnimationController(extraAddOnePage: false),
    permanent: false,
  );

  @override
  Widget build(BuildContext context) {
    final components = appBarBundle();
    return Scaffold(
      appBar: components.appBar,
      drawer: components.drawer,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Obx(
          () => Column(
            children: [
              const SizedBox(height: 12),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    controller.currentPizzaModel.tagDescription,
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton(
                    onPressed: null,
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.orange),
                    ),
                    child: Text(
                      controller.currentPizzaModel.tag,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // ⭐ Pizza Slide Effect
              const PizzaSlideEffect(),

              Stack(
                clipBehavior: Clip.none, // allow overflow
                children: [
                  FadeTransition(
                    opacity: controller.rowOpacity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(ImagesFiles.left, height: 100),
                        Image.asset(ImagesFiles.right, height: 100),
                      ],
                    ),
                  ),

                  Positioned(
                    bottom: -80, // move Stack up a bit
                    left: 0,
                    right: 0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          controller.currentPizzaModel.name,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12),
                        PizzaPageIndicator(),
                        SizedBox(height: 12),
                        Text(
                          '\$${controller.currentPizzaModel.price}',
                          textHeightBehavior: const TextHeightBehavior(
                            applyHeightToFirstAscent: false,
                            applyHeightToLastDescent: false,
                          ),
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            height: 1, // forces same baseline
                            color: Colors.black,
                            fontFamily: 'PlayfairDisplay',
                          ),
                        ),
                        SizedBox(height: 15),
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
                              controller.currentPizzaModel.name.substring(0, 1),
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
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 50),
            ],
          ),
        ),
      ),

      floatingActionButton: Transform.translate(
        offset: const Offset(0, -4),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 18.0),
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.shopping_cart,
                color: Colors.white,
                size: 32,
              ),
              onPressed: () {},
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
