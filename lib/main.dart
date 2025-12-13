import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nj_pizza_delivery/app.dart';
import 'package:get/get.dart';
import 'package:nj_pizza_delivery/app/home/cart/controller/cart_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.deepOrange,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
    ),
  );

  Get.put(CartController());
  runApp(MyApp());
}
