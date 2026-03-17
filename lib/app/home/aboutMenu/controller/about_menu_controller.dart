import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nj_pizza_delivery/app/home/aboutMenu/controller/pizza_topping_controller.dart';
import 'package:nj_pizza_delivery/app/home/home/model/product-model.dart';
import '../../../../constants/images_files.dart';

class AboutMenuController extends GetxController {
  final selectedSize = 'M'.obs;
  final quantity = 1.obs;

  Rx<ProductModel?> product = Rx<ProductModel?>(null);

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null && Get.arguments is ProductModel) {
      product.value = Get.arguments as ProductModel;
    }
  }

  // Arch image selection

  final archIcons = [
    ImagesFiles.onionIcon,
    ImagesFiles.tomatoIcon,
    ImagesFiles.sausageIcon,
    ImagesFiles.meetIcon,
    ImagesFiles.chilliIcon,
  ];

  RxInt selectedArchIndex = (2).obs;

  void changeSelectedArchIndex({required int index}) {
    selectedArchIndex.value = index;
    debugPrint('CLICKED -> $index');
  }

  void selectSize(String size) => selectedSize.value = size;
  void increment() => quantity.value++;
  void decrement() {
    if (quantity.value > 1) quantity.value--;
  }

  double get selectedSizePrice {
    if (product.value == null) return 0.0;
    return product.value!.sizes[selectedSize.value] ??
        product.value!.basePrice;
  }

  double get displayPrice => selectedSizePrice;


  double get totalPrice {
    final pizzaToppingController = Get.find<PizzaToppingController>();
    final extrasTotal = pizzaToppingController.selectedExtras
        .fold<double>(0.0, (sum, e) => sum + e.price);

    return (selectedSizePrice + extrasTotal) * quantity.value;
  }

}
