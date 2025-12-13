import 'package:get/get.dart';
import 'package:nj_pizza_delivery/app/auth/bindings/forget_password_controller_binding.dart';
import 'package:nj_pizza_delivery/app/auth/bindings/login_controller_binding.dart';
import 'package:nj_pizza_delivery/app/auth/bindings/registration_controller_binding.dart';
import 'package:nj_pizza_delivery/app/auth/forget_password.dart';
import 'package:nj_pizza_delivery/app/auth/login.dart';
import 'package:nj_pizza_delivery/app/auth/registration.dart';
import 'package:nj_pizza_delivery/app/home/cart/cart.dart';
import 'package:nj_pizza_delivery/app/home/contactUs/binding/contact_us_controller_binding.dart';
import 'package:nj_pizza_delivery/app/home/contactUs/contact_us.dart';
import 'package:nj_pizza_delivery/app/home/home.dart';
import 'package:nj_pizza_delivery/app/home/pizaa/NewOrderPizza/binding/new_order_pizza_controller_binding.dart';
import 'package:nj_pizza_delivery/app/home/pizaa/NewOrderPizza/order_pizza.dart';
import 'package:nj_pizza_delivery/app/home/pizaa/controller/pizza_slide_controller_binding.dart';
import 'package:nj_pizza_delivery/app/home/pizaa/pizaa_slide.dart';
import 'package:nj_pizza_delivery/app/home/profile/binding/profile_controller_binding.dart';
import 'package:nj_pizza_delivery/app/home/profile/profile.dart';
import 'package:nj_pizza_delivery/app/home/refundPolicy/refund_policy.dart';
import 'package:nj_pizza_delivery/app/home/report/binding/report_controller_binding.dart';
import 'package:nj_pizza_delivery/app/home/report/report.dart';
import 'package:nj_pizza_delivery/app/splash/binding/splash_controller_binding.dart';
import 'package:nj_pizza_delivery/app/splash/splash.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.PIZZASLIDER;

  static final routes = <GetPage>[
    GetPage(
      name: Routes.SPLASH,
      page: () => SplashScreen(),
      binding: SplashControllerBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => PizzaLoginScreen(),
      binding: LoginControllerBinding(),
    ),
    GetPage(
      name: Routes.REGISTRATION,
      page: () => PizzaRegistrationScreen(),
      binding: RegistrationControllerBinding(),
    ),
    GetPage(
      name: Routes.FORGETPASSWORD,
      page: () => ForgetPasswordScreen(),
      binding: ForgetPasswordControllerBinding(),
    ),
    GetPage(name: Routes.HOME, page: () => HomeScreen()),
    GetPage(
      name: Routes.PROFILE,
      page: () => ProfileScreen(),
      binding: ProfileControllerBinding(),
    ),
    GetPage(name: Routes.CART, page: () => CartScreen()),
    GetPage(name: Routes.REFUNDPOLICY, page: () => RefundPolicyPage()),
    GetPage(
      name: Routes.CONTACTUS,
      page: () => ContactUsScreen(),
      binding: ContactUsControllerBinding(),
    ),
    GetPage(
      name: Routes.REPORT,
      page: () => ReportScreen(),
      binding: ReportControllerBinding(),
    ),
    GetPage(
      name: Routes.PIZZASLIDER,
      page: () => PizzaSliderView(),
      binding: PizzaSlideControllerBinding(),
    ),
    GetPage(name: Routes.NEWORDERPIZZA, page: () => NewOrderPizza(),
    binding: NewOrderPizzaControllerBinding()
    ),
  ];
}
