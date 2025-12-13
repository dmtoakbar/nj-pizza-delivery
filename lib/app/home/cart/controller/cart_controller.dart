import 'package:get/get.dart';
import 'package:nj_pizza_delivery/app/home/cart/model/cart_item.dart';
import 'package:nj_pizza_delivery/constants/images_files.dart';

class CartController extends GetxController {
  var items = <CartItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Add dummy data
    items.addAll([
      CartItem(
        name: "Margherita Pizza",
        image: ImagesFiles.fullPizza,
        price: 5.99,
        quantity: 1,
      ),
      CartItem(
        name: "Pepperoni Pizza",
        image: ImagesFiles.fullPizza,
        price: 7.99,
        quantity: 2,
      ),
    ]);
  }

  void addItem(CartItem item) {
    items.add(item);
    items.refresh();
  }

  void removeItem(int index) {
    items.removeAt(index);
    items.refresh();
  }

  void increaseQuantity(int index) {
    items[index].quantity++;
    items.refresh();
  }

  void decreaseQuantity(int index) {
    if (items[index].quantity > 1) {
      items[index].quantity--;
      items.refresh();
    }
  }

  double get totalPrice =>
      items.fold(0, (sum, item) => sum + (item.price * item.quantity));
}
