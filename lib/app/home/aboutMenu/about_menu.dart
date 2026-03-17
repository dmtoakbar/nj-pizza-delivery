import 'dart:math';
import 'dart:math' as math;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nj_pizza_delivery/app/home/aboutMenu/controller/about_menu_controller.dart';
import 'package:nj_pizza_delivery/app/home/aboutMenu/controller/product_packing_animation_controller.dart';
import 'package:nj_pizza_delivery/app/home/aboutMenu/widgets/product_packing_animation.dart';
import 'package:nj_pizza_delivery/app/home/myFavourite/model/my_favourite_product_model.dart';
import 'package:nj_pizza_delivery/constants/images_files.dart';

import '../../../routes/app_routes.dart';
import '../cart/controller/cart_controller.dart';
import '../cart/model/cart_item.dart';
import '../myFavourite/controller/my_favourite_controller.dart';
import 'controller/pizza_topping_controller.dart';

class AboutMenuScreen extends GetView<AboutMenuController> {
  AboutMenuScreen({super.key});

  final productPackingAnimation = Get.put(
    ProductPackingAnimationController(),
    permanent: false,
  );
  final favController = Get.find<FavoritesController>();
  final cart = Get.find<CartController>();

  final pizzaToppingController = Get.find<PizzaToppingController>();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xFFFFE1C7),
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 0.6],
              colors: [
                Color(0xFFFFE1C7), // 👈 EXACT peach
                Colors.white,
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                _topBar(),

                Obx(() {
                  final product = controller.product.value;
                  if (product == null)
                    return Center(child: Text('No Product found'));
                  return Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          _pizzaImage(),
                          Transform.translate(
                            offset: const Offset(0, -90), // 👈 pull it upward
                            child: _yourCurvedIngredientWidget(),
                          ), // space for curve
                          Transform.translate(
                            offset: const Offset(0, -80),
                            child: _sizeSelector(),
                          ),

                          Transform.translate(
                            offset: const Offset(0, -60),
                            child: _infoSection(),
                          ),
                        ],
                      ),
                    ),
                  );
                }),

                Obx(() {
                  final product = controller.product.value;
                  if (product == null) return SizedBox.shrink();

                  return _bottomBar();
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- TOP BAR ----------------
  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          InkWell(
            child: const Icon(Icons.arrow_back_ios, size: 18),
            onTap: () => Get.back(),
          ),
          const Spacer(),
          const Text(
            'About Menu',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          Row(
            children: [
              Obx(() {
                final count = cart.items.length;

                return TweenAnimationBuilder<double>(
                  key: ValueKey(count), // 🔥 detects cart change
                  tween: Tween(begin: 0.85, end: 1.0),
                  duration: const Duration(milliseconds: 240),
                  curve: Curves.easeOut,
                  builder: (_, scale, child) {
                    return Transform.scale(scale: scale, child: child);
                  },
                  child: GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.CART);
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Image.asset(
                          ImagesFiles.shoppingBag,
                          height: 23,
                          color: Colors.black,
                        ),

                        /// 🔴 CART COUNT
                        Positioned(
                          top: -9,
                          right: -4,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              color: Color(0xFFEB5525),
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              count > 99 ? '99+' : '$count',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
          SizedBox(width: 10),
          Obx(() {
            final product = controller.product.value;
            if (product == null) return const SizedBox();
            final isFav = favController.favorites.any(
              (p) => p.id == product.id,
            );

            return GestureDetector(
              onTap: () {
                Get.toNamed(Routes.MYFAVORITE);
              },
              child: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
                size: 28,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _pizzaImage() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final centerX = constraints.maxWidth / 2;
        const double pizzaSize = 235;
        const double pizzaTop = 15;

        pizzaToppingController.setPizzaSpecs(
          Offset(centerX, pizzaTop + pizzaSize / 2),
          pizzaSize / 2,
        );

        return Obx(() {
          final product = controller.product.value;
          if (product == null) return const SizedBox();
          return ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: 200, // minimum height for the Stack
            ),
            child: IntrinsicHeight(
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  ProductPackingAnimation(),

                  /// GLOW BACKGROUND
                  Positioned(
                    top: 65,
                    child: IgnorePointer(
                      ignoring: productPackingAnimation.isVisible.value,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 150),
                        opacity:
                            productPackingAnimation.isVisible.value ? 0 : 1,
                        child: Transform.scale(
                          scale: 1.15,
                          child: Image.asset(
                            ImagesFiles.pizzaPadBlurBackground,
                            height: 235,
                            width: 240,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),

                  /// 🍕 PIZZA IMAGE (UNCHANGED SIZE)
                  Positioned(
                    top: pizzaTop,
                    child: IgnorePointer(
                      ignoring: productPackingAnimation.isCloseBoxShowing.value,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 150),
                        opacity:
                            productPackingAnimation.isCloseBoxShowing.value
                                ? 0
                                : 1,
                        child: CachedNetworkImage(
                          imageUrl: product.image,
                          height: 235,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),

                  /// ❤️ FAVORITE BUTTON (UNCHANGED)
                  if (!productPackingAnimation.isVisible.value)
                    Positioned(
                      top: 0,
                      right: 20,
                      child: Obx(() {
                        final product = controller.product.value;
                        if (product == null) return const SizedBox();

                        final favProduct = product.toFavorite();
                        final isFav = favController.isFavorite(favProduct.id);

                        return GestureDetector(
                          onTap: () => favController.toggleFavorite(favProduct),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: Colors.red,
                              size: 24,
                            ),
                          ),
                        );
                      }),
                    ),

                  /// 🧀 TOPPINGS (NOW CORRECT POSITION)
                  Obx(() {
                    return Stack(
                      children:
                          pizzaToppingController.toppings.map((item) {
                            return TweenAnimationBuilder<Offset>(
                              tween: Tween(
                                begin: item["start"],
                                end: item["end"],
                              ),
                              duration: const Duration(milliseconds: 700),
                              curve: Curves.easeOutBack,
                              builder: (_, value, __) {
                                return Positioned(
                                  left:
                                      pizzaToppingController.pizzaCenter.dx +
                                      value.dx -
                                      18,
                                  top:
                                      pizzaToppingController.pizzaCenter.dy +
                                      value.dy -
                                      18,
                                  child: _imageCacheNetwork(
                                    imageUrl: item["img"],
                                    width: 35,
                                  ),
                                );
                              },
                            );
                          }).toList(),
                    );
                  }),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  Widget _yourCurvedIngredientWidget() {
    return Obx(() {
      final items = pizzaToppingController.allIngredients;

      if (pizzaToppingController.isLoading.value) {
        return SizedBox(
          height: 240,
          child: Column(
            children: [
              Spacer(),
              CircularProgressIndicator(),
              SizedBox(height: 25),
            ],
          ),
        );
      }

      if (items.isEmpty) {
        return const SizedBox(height: 240);
      }

      return SizedBox(
        height: 240,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final itemWidth = constraints.maxWidth / 5; // 5 visible
            final center = constraints.maxWidth / 2;

            return ListView.builder(
              controller: pizzaToppingController.scrollController,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: items.length,
              itemExtent: itemWidth,
              itemBuilder: (context, index) {
                return AnimatedBuilder(
                  animation: pizzaToppingController.scrollController,
                  builder: (context, child) {
                    double offset = 0;

                    if (pizzaToppingController.scrollController.hasClients) {
                      offset = pizzaToppingController.scrollController.offset;
                    }

                    final itemCenter =
                        (index * itemWidth) - offset + itemWidth / 2;

                    final distanceFromCenter = (itemCenter - center).abs();

                    // curve intensity
                    final curveHeight =
                        80 *
                        (1 - (distanceFromCenter / center)).clamp(0.0, 1.0);

                    return Transform.translate(
                      offset: Offset(0, curveHeight),
                      child: Center(
                        child: ingredientDraggable(
                          items[index].image,
                          items[index].name,
                          index,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      );
    });
  }

  // ---------------- SIZE SELECTOR ----------------
  Widget _sizeSelector() {
    return Obx(() {
      return Column(
        children: [
          const Text('Size', style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:
                ['S', 'M', 'L'].map((size) {
                  final selected = controller.selectedSize.value == size;
                  return GestureDetector(
                    onTap: () => controller.selectSize(size),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color:
                            selected ? Color(0xFFEB5525) : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        size,
                        style: TextStyle(
                          color: selected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
        ],
      );
    });
  }

  // ---------------- INFO SECTION ----------------
  Widget _infoSection() {
    return Obx(() {
      final product = controller.product.value;
      if (product == null) return const SizedBox();
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),

            // ---------- TITLE ----------
            Text(
              product.name,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            // rating
            // Row(
            //   children: [
            //     const Icon(Icons.star, color: Colors.orange, size: 16),
            //     const SizedBox(width: 4),
            //     const Text('4.9', style: TextStyle(fontWeight: FontWeight.w500)),
            //   ],
            // ),
            const SizedBox(height: 10),
            // ---------- RATING + PRICE + QTY ----------
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Price
                Text(
                  '\$${controller.displayPrice.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),

                const Spacer(),

                // Quantity controller
                _qtyControl(),
              ],
            ),

            const SizedBox(height: 22),

            // ---------- DESCRIPTION ----------
            const Text(
              'Description',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),

            const SizedBox(height: 8),
            Text(
              product.description ?? '',
              style: TextStyle(color: Colors.grey, height: 1.5),
            ),

            const SizedBox(height: 24),
          ],
        ),
      );
    });
  }

  Widget _qtyControl() {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          GestureDetector(
            onTap: controller.decrement,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.remove, size: 16),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              controller.quantity.value.toString(),
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),

          GestureDetector(
            onTap: controller.increment,
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Color(0xFFEB5525),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, size: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // ingredient list
  Widget ingredientDraggable(String img, String name, int index) {
    return Obx(() {
      final isAdded = pizzaToppingController.selectedExtras.any(
        (e) => e.name == name,
      );
      final selected = pizzaToppingController.selectedIndex.value == index;
      return AbsorbPointer(
        absorbing: isAdded,
        child: LongPressDraggable(
          delay: const Duration(milliseconds: 100),
          data: img,
          feedback: _imageCacheNetwork(imageUrl: img, width: 40),

          childWhenDragging: Opacity(
            opacity: 0.3,
            child: _imageCacheNetwork(imageUrl: img, width: 40),
          ),
          onDragStarted: () {
            pizzaToppingController.selectIndex(index);
          },
          child: GestureDetector(
            onTap: () {
              pizzaToppingController.selectIndex(index);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: isAdded ? const Color(0xFFEB5525) : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      selected && !isAdded
                          ? const Color(0xFFEB5525)
                          : Colors.transparent,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Center(
                child: _imageCacheNetwork(imageUrl: img, width: 30, height: 30),
              ),
            ),
          ),
          onDragEnd: (details) {
            final pos = details.offset + const Offset(25, 25);
            if (pizzaToppingController.isInsidePizza(pos)) {
              pizzaToppingController.addBurstToppings(img);
            }
          },
        ),
      );
    });
  }

  Widget _imageCacheNetwork({
    required String imageUrl,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    BorderRadius? borderRadius,
  }) {
    final image = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder:
          (context, url) => Container(
            width: width,
            height: height,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.deepOrange,
            ),
          ),
      errorWidget:
          (context, url, error) => Container(
            width: width,
            height: height,
            alignment: Alignment.center,
            child: const Icon(Icons.broken_image, color: Colors.grey, size: 24),
          ),
    );

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius, child: image);
    }

    return image;
  }

  // ---------------- BOTTOM BAR ----------------

  Widget _bottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
      ),
      child: Obx(() {
        final extras = pizzaToppingController.selectedExtras;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// 🔽 SELECTED EXTRAS LIST
            if (extras.isNotEmpty)
              Align(
                alignment: AlignmentGeometry.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children:
                        extras.map((extra) {
                          return InputChip(
                            label: Text(
                              "${extra.name} (+\$${extra.price.toStringAsFixed(2)})",
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            onDeleted: () {
                              pizzaToppingController.removeExtra(extra);
                            },
                            deleteIcon: const Icon(Icons.close, size: 16),
                            deleteIconColor: Colors.red,
                            backgroundColor: Colors.grey.shade100,
                            shape: StadiumBorder(
                              side: BorderSide(color: Colors.grey.shade300),
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ),

            /// 🔽 TOTAL + BUTTON ROW
            Row(
              children: [
                // -------- LEFT TOTAL --------
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Total Order: ${controller.quantity.value}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${controller.totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                // -------- ADD TO CART BUTTON --------
                ElevatedButton(
                  onPressed: () async {
                    await productPackingAnimation.startPackingAnimation();
                    final product = controller.product.value;
                    if (product == null) return;
                    cart.addItem(
                      MyCartModel(
                        productId: product.id.toString(),
                        name: product.name,
                        image: product.image,
                        size: controller.selectedSize.value,
                        quantity: controller.quantity.value,
                        basePrice: product.basePrice.toDouble(),
                        discountPercentage:
                            product.discountPercentage.toDouble(),
                        finalPrice:
                            product.basePrice *
                            (1 - product.discountPercentage / 100),

                        extras: pizzaToppingController.selectedExtras.toList(),
                      ),
                    );
                    pizzaToppingController.selectedExtras.clear();
                    Get.toNamed(Routes.CART);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEB5525),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 34,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Add To Cart',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}
