import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nj_pizza_delivery/app/home/pizaa/controller/pizza_packing_controller.dart';
import 'package:nj_pizza_delivery/app/home/pizaa/controller/pizza_slider_controller.dart';
import 'package:nj_pizza_delivery/app/home/pizaa/widget/pizza_packing_widget.dart';
import 'package:nj_pizza_delivery/constants/images_files.dart';
import 'package:nj_pizza_delivery/routes/app_routes.dart';

class PizzaSlideEffect extends StatelessWidget {
  const PizzaSlideEffect({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<PizzaSliderController>();
    final pizzaPacking = Get.find<PizzaPackingAnimationController>();

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.velocity.pixelsPerSecond.dx > 0) {
          ctrl.slideInFromLeft();
        } else {
          ctrl.slideInFromRight();
        }
      },

      child: Center(
        child: Obx(() {
          return Stack(
            alignment: Alignment.center,
            clipBehavior:
                pizzaPacking.isVisible.value ? Clip.none : Clip.hardEdge,
            children: [
              PizzaPackingAnimationWidget(),
              // Plate behind
              IgnorePointer(
                ignoring: pizzaPacking.isVisible.value,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 150),
                  opacity: pizzaPacking.isVisible.value ? 0 : 1,
                  child: Transform.rotate(
                    angle: ctrl.plateRotation.value,
                    child: ClipRect(
                      child: Align(
                        alignment: Alignment.center,
                        heightFactor: 0.60,
                        child: Image.asset(
                          ImagesFiles.plateWithIngredient,
                          width: 400,
                          height: 400,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              ctrl.outGoing.value
                  ? SlideTransition(
                    position: ctrl.outGoingSlider,
                    child: GestureDetector(
                      onTap: () {},
                      child: Image.asset(
                        ctrl.previousPizzaModel.image,
                        width: 230,
                        height: 230,
                      ),
                    ),
                  )
                  : SizedBox.shrink(),
              // ⭐ Animated pizza (reactive)
              IgnorePointer(
                ignoring: pizzaPacking.isCloseBoxShowing.value,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 150),
                  opacity: pizzaPacking.isCloseBoxShowing.value ? 0 : 1,
                  child: SlideTransition(
                    position: ctrl.slideAnimation,
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed(
                          Routes.NEWORDERPIZZA,
                          arguments: {'pizzaId': ctrl.currentPizzaModel.id},
                        );
                      },
                      child: Image.asset(
                        ctrl.currentPizzaModel.image,
                        width: 230,
                        height: 230,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
